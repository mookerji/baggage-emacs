<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

  <title>misc/emacs/go-mode.el - The Go Programming Language</title>

<link type="text/css" rel="stylesheet" href="/doc/style.css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script type="text/javascript">window.jQuery || document.write(unescape("%3Cscript src='/doc/jquery.js' type='text/javascript'%3E%3C/script%3E"));</script>

<script type="text/javascript" src="/doc/play/playground.js"></script>

<script type="text/javascript" src="/doc/godocs.js"></script>

<link rel="search" type="application/opensearchdescription+xml" title="godoc" href="/opensearch.xml" />

<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(["_setAccount", "UA-11222381-2"]);
_gaq.push(["_trackPageview"]);
</script>
</head>
<body>

<div id="topbar" class="wide"><div class="container">

<form method="GET" action="/search">
<div id="menu">
<a href="/doc/">Documents</a>
<a href="/ref/">References</a>
<a href="/pkg/">Packages</a>
<a href="/project/">The Project</a>
<a href="/help/">Help</a>

<a id="playgroundButton" href="http://play.golang.org/" title="Show Go Playground">Play</a>

<input type="text" id="search" name="q" class="inactive" value="Search" placeholder="Search">
</div>
<div id="heading"><a href="/">The Go Programming Language</a></div>
</form>

</div></div>


<div id="playground" class="play">
	<div class="input"><textarea class="code">package main

import "fmt"

func main() {
	fmt.Println("Hello, 世界")
}</textarea></div>
	<div class="output"></div>
	<div class="buttons">
		<a class="run" title="Run this code [shift-enter]">Run</a>
		<a class="fmt" title="Format this code">Format</a>
		<a class="share" title="Share this code">Share</a>
	</div>
</div>


<div id="page" class="wide">
<div class="container">


  <div id="plusone"><g:plusone size="small" annotation="none"></g:plusone></div>
  <h1>Text file misc/emacs/go-mode.el</h1>




<div id="nav"></div>


<pre><a id="L1"></a><span class="ln">     1</span>	;;; go-mode.el --- Major mode for the Go programming language
<a id="L2"></a><span class="ln">     2</span>	
<a id="L3"></a><span class="ln">     3</span>	;; Copyright 2013 The Go Authors. All rights reserved.
<a id="L4"></a><span class="ln">     4</span>	;; Use of this source code is governed by a BSD-style
<a id="L5"></a><span class="ln">     5</span>	;; license that can be found in the LICENSE file.
<a id="L6"></a><span class="ln">     6</span>	
<a id="L7"></a><span class="ln">     7</span>	(require &#39;cl)
<a id="L8"></a><span class="ln">     8</span>	(require &#39;ffap)
<a id="L9"></a><span class="ln">     9</span>	(require &#39;url)
<a id="L10"></a><span class="ln">    10</span>	
<a id="L11"></a><span class="ln">    11</span>	;; XEmacs compatibility guidelines
<a id="L12"></a><span class="ln">    12</span>	;; - Minimum required version of XEmacs: 21.5.32
<a id="L13"></a><span class="ln">    13</span>	;;   - Feature that cannot be backported: POSIX character classes in
<a id="L14"></a><span class="ln">    14</span>	;;     regular expressions
<a id="L15"></a><span class="ln">    15</span>	;;   - Functions that could be backported but won&#39;t because 21.5.32
<a id="L16"></a><span class="ln">    16</span>	;;     covers them: plenty.
<a id="L17"></a><span class="ln">    17</span>	;;   - Features that are still partly broken:
<a id="L18"></a><span class="ln">    18</span>	;;     - godef will not work correctly if multibyte characters are
<a id="L19"></a><span class="ln">    19</span>	;;       being used
<a id="L20"></a><span class="ln">    20</span>	;;     - Fontification will not handle unicode correctly
<a id="L21"></a><span class="ln">    21</span>	;;
<a id="L22"></a><span class="ln">    22</span>	;; - Do not use \_&lt; and \_&gt; regexp delimiters directly; use
<a id="L23"></a><span class="ln">    23</span>	;;   go--regexp-enclose-in-symbol
<a id="L24"></a><span class="ln">    24</span>	;;
<a id="L25"></a><span class="ln">    25</span>	;; - The character `_` must not be a symbol constituent but a
<a id="L26"></a><span class="ln">    26</span>	;;   character constituent
<a id="L27"></a><span class="ln">    27</span>	;;
<a id="L28"></a><span class="ln">    28</span>	;; - Do not use process-lines
<a id="L29"></a><span class="ln">    29</span>	;;
<a id="L30"></a><span class="ln">    30</span>	;; - Use go--old-completion-list-style when using a plain list as the
<a id="L31"></a><span class="ln">    31</span>	;;   collection for completing-read
<a id="L32"></a><span class="ln">    32</span>	;;
<a id="L33"></a><span class="ln">    33</span>	;; - Use go--kill-whole-line instead of kill-whole-line (called
<a id="L34"></a><span class="ln">    34</span>	;;   kill-entire-line in XEmacs)
<a id="L35"></a><span class="ln">    35</span>	;;
<a id="L36"></a><span class="ln">    36</span>	;; - Use go--position-bytes instead of position-bytes
<a id="L37"></a><span class="ln">    37</span>	(defmacro go--xemacs-p ()
<a id="L38"></a><span class="ln">    38</span>	  `(featurep &#39;xemacs))
<a id="L39"></a><span class="ln">    39</span>	
<a id="L40"></a><span class="ln">    40</span>	(defalias &#39;go--kill-whole-line
<a id="L41"></a><span class="ln">    41</span>	  (if (fboundp &#39;kill-whole-line)
<a id="L42"></a><span class="ln">    42</span>	      &#39;kill-whole-line
<a id="L43"></a><span class="ln">    43</span>	    &#39;kill-entire-line))
<a id="L44"></a><span class="ln">    44</span>	
<a id="L45"></a><span class="ln">    45</span>	;; XEmacs unfortunately does not offer position-bytes. We can fall
<a id="L46"></a><span class="ln">    46</span>	;; back to just using (point), but it will be incorrect as soon as
<a id="L47"></a><span class="ln">    47</span>	;; multibyte characters are being used.
<a id="L48"></a><span class="ln">    48</span>	(if (fboundp &#39;position-bytes)
<a id="L49"></a><span class="ln">    49</span>	    (defalias &#39;go--position-bytes &#39;position-bytes)
<a id="L50"></a><span class="ln">    50</span>	  (defun go--position-bytes (point) point))
<a id="L51"></a><span class="ln">    51</span>	
<a id="L52"></a><span class="ln">    52</span>	(defun go--old-completion-list-style (list)
<a id="L53"></a><span class="ln">    53</span>	  (mapcar (lambda (x) (cons x nil)) list))
<a id="L54"></a><span class="ln">    54</span>	
<a id="L55"></a><span class="ln">    55</span>	;; GNU Emacs 24 has prog-mode, older GNU Emacs and XEmacs do not.
<a id="L56"></a><span class="ln">    56</span>	;; Ideally we&#39;d use defalias instead, but that breaks in XEmacs.
<a id="L57"></a><span class="ln">    57</span>	;;
<a id="L58"></a><span class="ln">    58</span>	;; TODO: If XEmacs decides to add prog-mode, change this to use
<a id="L59"></a><span class="ln">    59</span>	;; defalias to alias prog-mode or fundamental-mode to go--prog-mode
<a id="L60"></a><span class="ln">    60</span>	;; and use that in define-derived-mode.
<a id="L61"></a><span class="ln">    61</span>	(if (not (fboundp &#39;prog-mode))
<a id="L62"></a><span class="ln">    62</span>	    (define-derived-mode prog-mode fundamental-mode &#34;&#34; &#34;&#34;))
<a id="L63"></a><span class="ln">    63</span>	
<a id="L64"></a><span class="ln">    64</span>	(defun go--regexp-enclose-in-symbol (s)
<a id="L65"></a><span class="ln">    65</span>	  ;; XEmacs does not support \_&lt;, GNU Emacs does. In GNU Emacs we make
<a id="L66"></a><span class="ln">    66</span>	  ;; extensive use of \_&lt; to support unicode in identifiers. Until we
<a id="L67"></a><span class="ln">    67</span>	  ;; come up with a better solution for XEmacs, this solution will
<a id="L68"></a><span class="ln">    68</span>	  ;; break fontification in XEmacs for identifiers such as &#34;typeµ&#34;.
<a id="L69"></a><span class="ln">    69</span>	  ;; XEmacs will consider &#34;type&#34; a keyword, GNU Emacs won&#39;t.
<a id="L70"></a><span class="ln">    70</span>	
<a id="L71"></a><span class="ln">    71</span>	  (if (go--xemacs-p)
<a id="L72"></a><span class="ln">    72</span>	      (concat &#34;\\&lt;&#34; s &#34;\\&gt;&#34;)
<a id="L73"></a><span class="ln">    73</span>	    (concat &#34;\\_&lt;&#34; s &#34;\\_&gt;&#34;)))
<a id="L74"></a><span class="ln">    74</span>	
<a id="L75"></a><span class="ln">    75</span>	(defconst go-dangling-operators-regexp &#34;[^-]-\\|[^+]\\+\\|[/*&amp;&gt;&lt;.=|^]&#34;)
<a id="L76"></a><span class="ln">    76</span>	(defconst go-identifier-regexp &#34;[[:word:][:multibyte:]]+&#34;)
<a id="L77"></a><span class="ln">    77</span>	(defconst go-label-regexp go-identifier-regexp)
<a id="L78"></a><span class="ln">    78</span>	(defconst go-type-regexp &#34;[[:word:][:multibyte:]*]+&#34;)
<a id="L79"></a><span class="ln">    79</span>	(defconst go-func-regexp (concat (go--regexp-enclose-in-symbol &#34;func&#34;) &#34;\\s *\\(&#34; go-identifier-regexp &#34;\\)&#34;))
<a id="L80"></a><span class="ln">    80</span>	(defconst go-func-meth-regexp (concat (go--regexp-enclose-in-symbol &#34;func&#34;) &#34;\\s *\\(?:(\\s *&#34; go-identifier-regexp &#34;\\s +&#34; go-type-regexp &#34;\\s *)\\s *\\)?\\(&#34; go-identifier-regexp &#34;\\)(&#34;))
<a id="L81"></a><span class="ln">    81</span>	(defconst go-builtins
<a id="L82"></a><span class="ln">    82</span>	  &#39;(&#34;append&#34; &#34;cap&#34;   &#34;close&#34;   &#34;complex&#34; &#34;copy&#34;
<a id="L83"></a><span class="ln">    83</span>	    &#34;delete&#34; &#34;imag&#34;  &#34;len&#34;     &#34;make&#34;    &#34;new&#34;
<a id="L84"></a><span class="ln">    84</span>	    &#34;panic&#34;  &#34;print&#34; &#34;println&#34; &#34;real&#34;    &#34;recover&#34;)
<a id="L85"></a><span class="ln">    85</span>	  &#34;All built-in functions in the Go language. Used for font locking.&#34;)
<a id="L86"></a><span class="ln">    86</span>	
<a id="L87"></a><span class="ln">    87</span>	(defconst go-mode-keywords
<a id="L88"></a><span class="ln">    88</span>	  &#39;(&#34;break&#34;    &#34;default&#34;     &#34;func&#34;   &#34;interface&#34; &#34;select&#34;
<a id="L89"></a><span class="ln">    89</span>	    &#34;case&#34;     &#34;defer&#34;       &#34;go&#34;     &#34;map&#34;       &#34;struct&#34;
<a id="L90"></a><span class="ln">    90</span>	    &#34;chan&#34;     &#34;else&#34;        &#34;goto&#34;   &#34;package&#34;   &#34;switch&#34;
<a id="L91"></a><span class="ln">    91</span>	    &#34;const&#34;    &#34;fallthrough&#34; &#34;if&#34;     &#34;range&#34;     &#34;type&#34;
<a id="L92"></a><span class="ln">    92</span>	    &#34;continue&#34; &#34;for&#34;         &#34;import&#34; &#34;return&#34;    &#34;var&#34;)
<a id="L93"></a><span class="ln">    93</span>	  &#34;All keywords in the Go language.  Used for font locking.&#34;)
<a id="L94"></a><span class="ln">    94</span>	
<a id="L95"></a><span class="ln">    95</span>	(defconst go-constants &#39;(&#34;nil&#34; &#34;true&#34; &#34;false&#34; &#34;iota&#34;))
<a id="L96"></a><span class="ln">    96</span>	(defconst go-type-name-regexp (concat &#34;\\(?:[*(]\\)*\\(?:&#34; go-identifier-regexp &#34;\\.\\)?\\(&#34; go-identifier-regexp &#34;\\)&#34;))
<a id="L97"></a><span class="ln">    97</span>	
<a id="L98"></a><span class="ln">    98</span>	(defvar go-dangling-cache)
<a id="L99"></a><span class="ln">    99</span>	(defvar go-godoc-history nil)
<a id="L100"></a><span class="ln">   100</span>	
<a id="L101"></a><span class="ln">   101</span>	(defgroup go nil
<a id="L102"></a><span class="ln">   102</span>	  &#34;Major mode for editing Go code&#34;
<a id="L103"></a><span class="ln">   103</span>	  :group &#39;languages)
<a id="L104"></a><span class="ln">   104</span>	
<a id="L105"></a><span class="ln">   105</span>	(defcustom go-fontify-function-calls t
<a id="L106"></a><span class="ln">   106</span>	  &#34;Fontify function and method calls if this is non-nil.&#34;
<a id="L107"></a><span class="ln">   107</span>	  :type &#39;boolean
<a id="L108"></a><span class="ln">   108</span>	  :group &#39;go)
<a id="L109"></a><span class="ln">   109</span>	
<a id="L110"></a><span class="ln">   110</span>	(defvar go-mode-syntax-table
<a id="L111"></a><span class="ln">   111</span>	  (let ((st (make-syntax-table)))
<a id="L112"></a><span class="ln">   112</span>	    (modify-syntax-entry ?+  &#34;.&#34; st)
<a id="L113"></a><span class="ln">   113</span>	    (modify-syntax-entry ?-  &#34;.&#34; st)
<a id="L114"></a><span class="ln">   114</span>	    (modify-syntax-entry ?%  &#34;.&#34; st)
<a id="L115"></a><span class="ln">   115</span>	    (modify-syntax-entry ?&amp;  &#34;.&#34; st)
<a id="L116"></a><span class="ln">   116</span>	    (modify-syntax-entry ?|  &#34;.&#34; st)
<a id="L117"></a><span class="ln">   117</span>	    (modify-syntax-entry ?^  &#34;.&#34; st)
<a id="L118"></a><span class="ln">   118</span>	    (modify-syntax-entry ?!  &#34;.&#34; st)
<a id="L119"></a><span class="ln">   119</span>	    (modify-syntax-entry ?=  &#34;.&#34; st)
<a id="L120"></a><span class="ln">   120</span>	    (modify-syntax-entry ?&lt;  &#34;.&#34; st)
<a id="L121"></a><span class="ln">   121</span>	    (modify-syntax-entry ?&gt;  &#34;.&#34; st)
<a id="L122"></a><span class="ln">   122</span>	    (modify-syntax-entry ?/ (if (go--xemacs-p) &#34;. 1456&#34; &#34;. 124b&#34;) st)
<a id="L123"></a><span class="ln">   123</span>	    (modify-syntax-entry ?*  &#34;. 23&#34; st)
<a id="L124"></a><span class="ln">   124</span>	    (modify-syntax-entry ?\n &#34;&gt; b&#34; st)
<a id="L125"></a><span class="ln">   125</span>	    (modify-syntax-entry ?\&#34; &#34;\&#34;&#34; st)
<a id="L126"></a><span class="ln">   126</span>	    (modify-syntax-entry ?\&#39; &#34;\&#34;&#34; st)
<a id="L127"></a><span class="ln">   127</span>	    (modify-syntax-entry ?`  &#34;\&#34;&#34; st)
<a id="L128"></a><span class="ln">   128</span>	    (modify-syntax-entry ?\\ &#34;\\&#34; st)
<a id="L129"></a><span class="ln">   129</span>	    ;; It would be nicer to have _ as a symbol constituent, but that
<a id="L130"></a><span class="ln">   130</span>	    ;; would trip up XEmacs, which does not support the \_&lt; anchor
<a id="L131"></a><span class="ln">   131</span>	    (modify-syntax-entry ?_  &#34;w&#34; st)
<a id="L132"></a><span class="ln">   132</span>	
<a id="L133"></a><span class="ln">   133</span>	    st)
<a id="L134"></a><span class="ln">   134</span>	  &#34;Syntax table for Go mode.&#34;)
<a id="L135"></a><span class="ln">   135</span>	
<a id="L136"></a><span class="ln">   136</span>	(defun go--build-font-lock-keywords ()
<a id="L137"></a><span class="ln">   137</span>	  ;; we cannot use &#39;symbols in regexp-opt because emacs &lt;24 doesn&#39;t
<a id="L138"></a><span class="ln">   138</span>	  ;; understand that
<a id="L139"></a><span class="ln">   139</span>	  (append
<a id="L140"></a><span class="ln">   140</span>	   `((,(go--regexp-enclose-in-symbol (regexp-opt go-mode-keywords t)) . font-lock-keyword-face)
<a id="L141"></a><span class="ln">   141</span>	     (,(go--regexp-enclose-in-symbol (regexp-opt go-builtins t)) . font-lock-builtin-face)
<a id="L142"></a><span class="ln">   142</span>	     (,(go--regexp-enclose-in-symbol (regexp-opt go-constants t)) . font-lock-constant-face)
<a id="L143"></a><span class="ln">   143</span>	     (,go-func-regexp 1 font-lock-function-name-face)) ;; function (not method) name
<a id="L144"></a><span class="ln">   144</span>	
<a id="L145"></a><span class="ln">   145</span>	   (if go-fontify-function-calls
<a id="L146"></a><span class="ln">   146</span>	       `((,(concat &#34;\\(&#34; go-identifier-regexp &#34;\\)[[:space:]]*(&#34;) 1 font-lock-function-name-face) ;; function call/method name
<a id="L147"></a><span class="ln">   147</span>	         (,(concat &#34;(\\(&#34; go-identifier-regexp &#34;\\))[[:space:]]*(&#34;) 1 font-lock-function-name-face)) ;; bracketed function call
<a id="L148"></a><span class="ln">   148</span>	     `((,go-func-meth-regexp 1 font-lock-function-name-face))) ;; method name
<a id="L149"></a><span class="ln">   149</span>	
<a id="L150"></a><span class="ln">   150</span>	   `(
<a id="L151"></a><span class="ln">   151</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;type&#34;) &#34;[[:space:]]*\\([^[:space:]]+\\)&#34;) 1 font-lock-type-face) ;; types
<a id="L152"></a><span class="ln">   152</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;type&#34;) &#34;[[:space:]]*&#34; go-identifier-regexp &#34;[[:space:]]*&#34; go-type-name-regexp) 1 font-lock-type-face) ;; types
<a id="L153"></a><span class="ln">   153</span>	     (,(concat &#34;[^[:word:][:multibyte:]]\\[\\([[:digit:]]+\\|\\.\\.\\.\\)?\\]&#34; go-type-name-regexp) 2 font-lock-type-face) ;; Arrays/slices
<a id="L154"></a><span class="ln">   154</span>	     (,(concat &#34;\\(&#34; go-identifier-regexp &#34;\\)&#34; &#34;{&#34;) 1 font-lock-type-face)
<a id="L155"></a><span class="ln">   155</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;map&#34;) &#34;\\[[^]]+\\]&#34; go-type-name-regexp) 1 font-lock-type-face) ;; map value type
<a id="L156"></a><span class="ln">   156</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;map&#34;) &#34;\\[&#34; go-type-name-regexp) 1 font-lock-type-face) ;; map key type
<a id="L157"></a><span class="ln">   157</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;chan&#34;) &#34;[[:space:]]*\\(?:&lt;-\\)?&#34; go-type-name-regexp) 1 font-lock-type-face) ;; channel type
<a id="L158"></a><span class="ln">   158</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;\\(?:new\\|make\\)&#34;) &#34;\\(?:[[:space:]]\\|)\\)*(&#34; go-type-name-regexp) 1 font-lock-type-face) ;; new/make type
<a id="L159"></a><span class="ln">   159</span>	     ;; TODO do we actually need this one or isn&#39;t it just a function call?
<a id="L160"></a><span class="ln">   160</span>	     (,(concat &#34;\\.\\s *(&#34; go-type-name-regexp) 1 font-lock-type-face) ;; Type conversion
<a id="L161"></a><span class="ln">   161</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;func&#34;) &#34;[[:space:]]+(&#34; go-identifier-regexp &#34;[[:space:]]+&#34; go-type-name-regexp &#34;)&#34;) 1 font-lock-type-face) ;; Method receiver
<a id="L162"></a><span class="ln">   162</span>	     ;; Like the original go-mode this also marks compound literal
<a id="L163"></a><span class="ln">   163</span>	     ;; fields. There, it was marked as to fix, but I grew quite
<a id="L164"></a><span class="ln">   164</span>	     ;; accustomed to it, so it&#39;ll stay for now.
<a id="L165"></a><span class="ln">   165</span>	     (,(concat &#34;^[[:space:]]*\\(&#34; go-label-regexp &#34;\\)[[:space:]]*:\\(\\S.\\|$\\)&#34;) 1 font-lock-constant-face) ;; Labels and compound literal fields
<a id="L166"></a><span class="ln">   166</span>	     (,(concat (go--regexp-enclose-in-symbol &#34;\\(goto\\|break\\|continue\\)&#34;) &#34;[[:space:]]*\\(&#34; go-label-regexp &#34;\\)&#34;) 2 font-lock-constant-face)))) ;; labels in goto/break/continue
<a id="L167"></a><span class="ln">   167</span>	
<a id="L168"></a><span class="ln">   168</span>	(defvar go-mode-map
<a id="L169"></a><span class="ln">   169</span>	  (let ((m (make-sparse-keymap)))
<a id="L170"></a><span class="ln">   170</span>	    (define-key m &#34;}&#34; &#39;go-mode-insert-and-indent)
<a id="L171"></a><span class="ln">   171</span>	    (define-key m &#34;)&#34; &#39;go-mode-insert-and-indent)
<a id="L172"></a><span class="ln">   172</span>	    (define-key m &#34;,&#34; &#39;go-mode-insert-and-indent)
<a id="L173"></a><span class="ln">   173</span>	    (define-key m &#34;:&#34; &#39;go-mode-insert-and-indent)
<a id="L174"></a><span class="ln">   174</span>	    (define-key m &#34;=&#34; &#39;go-mode-insert-and-indent)
<a id="L175"></a><span class="ln">   175</span>	    (define-key m (kbd &#34;C-c C-a&#34;) &#39;go-import-add)
<a id="L176"></a><span class="ln">   176</span>	    (define-key m (kbd &#34;C-c C-j&#34;) &#39;godef-jump)
<a id="L177"></a><span class="ln">   177</span>	    (define-key m (kbd &#34;C-c C-d&#34;) &#39;godef-describe)
<a id="L178"></a><span class="ln">   178</span>	    m)
<a id="L179"></a><span class="ln">   179</span>	  &#34;Keymap used by Go mode to implement electric keys.&#34;)
<a id="L180"></a><span class="ln">   180</span>	
<a id="L181"></a><span class="ln">   181</span>	(defun go-mode-insert-and-indent (key)
<a id="L182"></a><span class="ln">   182</span>	  &#34;Invoke the global binding of KEY, then reindent the line.&#34;
<a id="L183"></a><span class="ln">   183</span>	
<a id="L184"></a><span class="ln">   184</span>	  (interactive (list (this-command-keys)))
<a id="L185"></a><span class="ln">   185</span>	  (call-interactively (lookup-key (current-global-map) key))
<a id="L186"></a><span class="ln">   186</span>	  (indent-according-to-mode))
<a id="L187"></a><span class="ln">   187</span>	
<a id="L188"></a><span class="ln">   188</span>	(defmacro go-paren-level ()
<a id="L189"></a><span class="ln">   189</span>	  `(car (syntax-ppss)))
<a id="L190"></a><span class="ln">   190</span>	
<a id="L191"></a><span class="ln">   191</span>	(defmacro go-in-string-or-comment-p ()
<a id="L192"></a><span class="ln">   192</span>	  `(nth 8 (syntax-ppss)))
<a id="L193"></a><span class="ln">   193</span>	
<a id="L194"></a><span class="ln">   194</span>	(defmacro go-in-string-p ()
<a id="L195"></a><span class="ln">   195</span>	  `(nth 3 (syntax-ppss)))
<a id="L196"></a><span class="ln">   196</span>	
<a id="L197"></a><span class="ln">   197</span>	(defmacro go-in-comment-p ()
<a id="L198"></a><span class="ln">   198</span>	  `(nth 4 (syntax-ppss)))
<a id="L199"></a><span class="ln">   199</span>	
<a id="L200"></a><span class="ln">   200</span>	(defmacro go-goto-beginning-of-string-or-comment ()
<a id="L201"></a><span class="ln">   201</span>	  `(goto-char (nth 8 (syntax-ppss))))
<a id="L202"></a><span class="ln">   202</span>	
<a id="L203"></a><span class="ln">   203</span>	(defun go--backward-irrelevant (&amp;optional stop-at-string)
<a id="L204"></a><span class="ln">   204</span>	  &#34;Skips backwards over any characters that are irrelevant for
<a id="L205"></a><span class="ln">   205</span>	indentation and related tasks.
<a id="L206"></a><span class="ln">   206</span>	
<a id="L207"></a><span class="ln">   207</span>	It skips over whitespace, comments, cases and labels and, if
<a id="L208"></a><span class="ln">   208</span>	STOP-AT-STRING is not true, over strings.&#34;
<a id="L209"></a><span class="ln">   209</span>	
<a id="L210"></a><span class="ln">   210</span>	  (let (pos (start-pos (point)))
<a id="L211"></a><span class="ln">   211</span>	    (skip-chars-backward &#34;\n\s\t&#34;)
<a id="L212"></a><span class="ln">   212</span>	    (if (and (save-excursion (beginning-of-line) (go-in-string-p)) (looking-back &#34;`&#34;) (not stop-at-string))
<a id="L213"></a><span class="ln">   213</span>	        (backward-char))
<a id="L214"></a><span class="ln">   214</span>	    (if (and (go-in-string-p) (not stop-at-string))
<a id="L215"></a><span class="ln">   215</span>	        (go-goto-beginning-of-string-or-comment))
<a id="L216"></a><span class="ln">   216</span>	    (if (looking-back &#34;\\*/&#34;)
<a id="L217"></a><span class="ln">   217</span>	        (backward-char))
<a id="L218"></a><span class="ln">   218</span>	    (if (go-in-comment-p)
<a id="L219"></a><span class="ln">   219</span>	        (go-goto-beginning-of-string-or-comment))
<a id="L220"></a><span class="ln">   220</span>	    (setq pos (point))
<a id="L221"></a><span class="ln">   221</span>	    (beginning-of-line)
<a id="L222"></a><span class="ln">   222</span>	    (if (or (looking-at (concat &#34;^&#34; go-label-regexp &#34;:&#34;)) (looking-at &#34;^[[:space:]]*\\(case .+\\|default\\):&#34;))
<a id="L223"></a><span class="ln">   223</span>	        (end-of-line 0)
<a id="L224"></a><span class="ln">   224</span>	      (goto-char pos))
<a id="L225"></a><span class="ln">   225</span>	    (if (/= start-pos (point))
<a id="L226"></a><span class="ln">   226</span>	        (go--backward-irrelevant stop-at-string))
<a id="L227"></a><span class="ln">   227</span>	    (/= start-pos (point))))
<a id="L228"></a><span class="ln">   228</span>	
<a id="L229"></a><span class="ln">   229</span>	(defun go--buffer-narrowed-p ()
<a id="L230"></a><span class="ln">   230</span>	  &#34;Return non-nil if the current buffer is narrowed.&#34;
<a id="L231"></a><span class="ln">   231</span>	  (/= (buffer-size)
<a id="L232"></a><span class="ln">   232</span>	      (- (point-max)
<a id="L233"></a><span class="ln">   233</span>	         (point-min))))
<a id="L234"></a><span class="ln">   234</span>	
<a id="L235"></a><span class="ln">   235</span>	(defun go-previous-line-has-dangling-op-p ()
<a id="L236"></a><span class="ln">   236</span>	  &#34;Returns non-nil if the current line is a continuation line.&#34;
<a id="L237"></a><span class="ln">   237</span>	  (let* ((cur-line (line-number-at-pos))
<a id="L238"></a><span class="ln">   238</span>	         (val (gethash cur-line go-dangling-cache &#39;nope)))
<a id="L239"></a><span class="ln">   239</span>	    (if (or (go--buffer-narrowed-p) (equal val &#39;nope))
<a id="L240"></a><span class="ln">   240</span>	        (save-excursion
<a id="L241"></a><span class="ln">   241</span>	          (beginning-of-line)
<a id="L242"></a><span class="ln">   242</span>	          (go--backward-irrelevant t)
<a id="L243"></a><span class="ln">   243</span>	          (setq val (looking-back go-dangling-operators-regexp))
<a id="L244"></a><span class="ln">   244</span>	          (if (not (go--buffer-narrowed-p))
<a id="L245"></a><span class="ln">   245</span>	              (puthash cur-line val go-dangling-cache))))
<a id="L246"></a><span class="ln">   246</span>	    val))
<a id="L247"></a><span class="ln">   247</span>	
<a id="L248"></a><span class="ln">   248</span>	(defun go--at-function-definition ()
<a id="L249"></a><span class="ln">   249</span>	  &#34;Return non-nil if point is on the opening curly brace of a
<a id="L250"></a><span class="ln">   250</span>	function definition.
<a id="L251"></a><span class="ln">   251</span>	
<a id="L252"></a><span class="ln">   252</span>	We do this by first calling (beginning-of-defun), which will take
<a id="L253"></a><span class="ln">   253</span>	us to the start of *some* function. We then look for the opening
<a id="L254"></a><span class="ln">   254</span>	curly brace of that function and compare its position against the
<a id="L255"></a><span class="ln">   255</span>	curly brace we are checking. If they match, we return non-nil.&#34;
<a id="L256"></a><span class="ln">   256</span>	  (if (= (char-after) ?\{)
<a id="L257"></a><span class="ln">   257</span>	      (save-excursion
<a id="L258"></a><span class="ln">   258</span>	        (let ((old-point (point))
<a id="L259"></a><span class="ln">   259</span>	              start-nesting)
<a id="L260"></a><span class="ln">   260</span>	          (beginning-of-defun)
<a id="L261"></a><span class="ln">   261</span>	          (when (looking-at &#34;func &#34;)
<a id="L262"></a><span class="ln">   262</span>	            (setq start-nesting (go-paren-level))
<a id="L263"></a><span class="ln">   263</span>	            (skip-chars-forward &#34;^{&#34;)
<a id="L264"></a><span class="ln">   264</span>	            (while (&gt; (go-paren-level) start-nesting)
<a id="L265"></a><span class="ln">   265</span>	              (forward-char)
<a id="L266"></a><span class="ln">   266</span>	              (skip-chars-forward &#34;^{&#34;) 0)
<a id="L267"></a><span class="ln">   267</span>	            (if (and (= (go-paren-level) start-nesting) (= old-point (point)))
<a id="L268"></a><span class="ln">   268</span>	                t))))))
<a id="L269"></a><span class="ln">   269</span>	
<a id="L270"></a><span class="ln">   270</span>	(defun go-goto-opening-parenthesis (&amp;optional char)
<a id="L271"></a><span class="ln">   271</span>	  (let ((start-nesting (go-paren-level)))
<a id="L272"></a><span class="ln">   272</span>	    (while (and (not (bobp))
<a id="L273"></a><span class="ln">   273</span>	                (&gt;= (go-paren-level) start-nesting))
<a id="L274"></a><span class="ln">   274</span>	      (if (zerop (skip-chars-backward
<a id="L275"></a><span class="ln">   275</span>	                  (if char
<a id="L276"></a><span class="ln">   276</span>	                      (case char (?\] &#34;^[&#34;) (?\} &#34;^{&#34;) (?\) &#34;^(&#34;))
<a id="L277"></a><span class="ln">   277</span>	                    &#34;^[{(&#34;)))
<a id="L278"></a><span class="ln">   278</span>	          (if (go-in-string-or-comment-p)
<a id="L279"></a><span class="ln">   279</span>	              (go-goto-beginning-of-string-or-comment)
<a id="L280"></a><span class="ln">   280</span>	            (backward-char))))))
<a id="L281"></a><span class="ln">   281</span>	
<a id="L282"></a><span class="ln">   282</span>	(defun go--indentation-for-opening-parenthesis ()
<a id="L283"></a><span class="ln">   283</span>	  &#34;Return the semantic indentation for the current opening parenthesis.
<a id="L284"></a><span class="ln">   284</span>	
<a id="L285"></a><span class="ln">   285</span>	If point is on an opening curly brace and said curly brace
<a id="L286"></a><span class="ln">   286</span>	belongs to a function declaration, the indentation of the func
<a id="L287"></a><span class="ln">   287</span>	keyword will be returned. Otherwise the indentation of the
<a id="L288"></a><span class="ln">   288</span>	current line will be returned.&#34;
<a id="L289"></a><span class="ln">   289</span>	  (save-excursion
<a id="L290"></a><span class="ln">   290</span>	    (if (go--at-function-definition)
<a id="L291"></a><span class="ln">   291</span>	        (progn
<a id="L292"></a><span class="ln">   292</span>	          (beginning-of-defun)
<a id="L293"></a><span class="ln">   293</span>	          (current-indentation))
<a id="L294"></a><span class="ln">   294</span>	      (current-indentation))))
<a id="L295"></a><span class="ln">   295</span>	
<a id="L296"></a><span class="ln">   296</span>	(defun go-indentation-at-point ()
<a id="L297"></a><span class="ln">   297</span>	  (save-excursion
<a id="L298"></a><span class="ln">   298</span>	    (let (start-nesting (outindent 0))
<a id="L299"></a><span class="ln">   299</span>	      (back-to-indentation)
<a id="L300"></a><span class="ln">   300</span>	      (setq start-nesting (go-paren-level))
<a id="L301"></a><span class="ln">   301</span>	
<a id="L302"></a><span class="ln">   302</span>	      (cond
<a id="L303"></a><span class="ln">   303</span>	       ((go-in-string-p)
<a id="L304"></a><span class="ln">   304</span>	        (current-indentation))
<a id="L305"></a><span class="ln">   305</span>	       ((looking-at &#34;[])}]&#34;)
<a id="L306"></a><span class="ln">   306</span>	        (go-goto-opening-parenthesis (char-after))
<a id="L307"></a><span class="ln">   307</span>	        (if (go-previous-line-has-dangling-op-p)
<a id="L308"></a><span class="ln">   308</span>	            (- (current-indentation) tab-width)
<a id="L309"></a><span class="ln">   309</span>	          (go--indentation-for-opening-parenthesis)))
<a id="L310"></a><span class="ln">   310</span>	       ((progn (go--backward-irrelevant t) (looking-back go-dangling-operators-regexp))
<a id="L311"></a><span class="ln">   311</span>	        ;; only one nesting for all dangling operators in one operation
<a id="L312"></a><span class="ln">   312</span>	        (if (go-previous-line-has-dangling-op-p)
<a id="L313"></a><span class="ln">   313</span>	            (current-indentation)
<a id="L314"></a><span class="ln">   314</span>	          (+ (current-indentation) tab-width)))
<a id="L315"></a><span class="ln">   315</span>	       ((zerop (go-paren-level))
<a id="L316"></a><span class="ln">   316</span>	        0)
<a id="L317"></a><span class="ln">   317</span>	       ((progn (go-goto-opening-parenthesis) (&lt; (go-paren-level) start-nesting))
<a id="L318"></a><span class="ln">   318</span>	        (if (go-previous-line-has-dangling-op-p)
<a id="L319"></a><span class="ln">   319</span>	            (current-indentation)
<a id="L320"></a><span class="ln">   320</span>	          (+ (go--indentation-for-opening-parenthesis) tab-width)))
<a id="L321"></a><span class="ln">   321</span>	       (t
<a id="L322"></a><span class="ln">   322</span>	        (current-indentation))))))
<a id="L323"></a><span class="ln">   323</span>	
<a id="L324"></a><span class="ln">   324</span>	(defun go-mode-indent-line ()
<a id="L325"></a><span class="ln">   325</span>	  (interactive)
<a id="L326"></a><span class="ln">   326</span>	  (let (indent
<a id="L327"></a><span class="ln">   327</span>	        shift-amt
<a id="L328"></a><span class="ln">   328</span>	        end
<a id="L329"></a><span class="ln">   329</span>	        (pos (- (point-max) (point)))
<a id="L330"></a><span class="ln">   330</span>	        (point (point))
<a id="L331"></a><span class="ln">   331</span>	        (beg (line-beginning-position)))
<a id="L332"></a><span class="ln">   332</span>	    (back-to-indentation)
<a id="L333"></a><span class="ln">   333</span>	    (if (go-in-string-or-comment-p)
<a id="L334"></a><span class="ln">   334</span>	        (goto-char point)
<a id="L335"></a><span class="ln">   335</span>	      (setq indent (go-indentation-at-point))
<a id="L336"></a><span class="ln">   336</span>	      (if (looking-at (concat go-label-regexp &#34;:\\([[:space:]]*/.+\\)?$\\|case .+:\\|default:&#34;))
<a id="L337"></a><span class="ln">   337</span>	          (decf indent tab-width))
<a id="L338"></a><span class="ln">   338</span>	      (setq shift-amt (- indent (current-column)))
<a id="L339"></a><span class="ln">   339</span>	      (if (zerop shift-amt)
<a id="L340"></a><span class="ln">   340</span>	          nil
<a id="L341"></a><span class="ln">   341</span>	        (delete-region beg (point))
<a id="L342"></a><span class="ln">   342</span>	        (indent-to indent))
<a id="L343"></a><span class="ln">   343</span>	      ;; If initial point was within line&#39;s indentation,
<a id="L344"></a><span class="ln">   344</span>	      ;; position after the indentation.  Else stay at same point in text.
<a id="L345"></a><span class="ln">   345</span>	      (if (&gt; (- (point-max) pos) (point))
<a id="L346"></a><span class="ln">   346</span>	          (goto-char (- (point-max) pos))))))
<a id="L347"></a><span class="ln">   347</span>	
<a id="L348"></a><span class="ln">   348</span>	(defun go-beginning-of-defun (&amp;optional count)
<a id="L349"></a><span class="ln">   349</span>	  (unless count (setq count 1))
<a id="L350"></a><span class="ln">   350</span>	  (let ((first t) failure)
<a id="L351"></a><span class="ln">   351</span>	    (dotimes (i (abs count))
<a id="L352"></a><span class="ln">   352</span>	      (while (and (not failure)
<a id="L353"></a><span class="ln">   353</span>	                  (or first (go-in-string-or-comment-p)))
<a id="L354"></a><span class="ln">   354</span>	        (if (&gt;= count 0)
<a id="L355"></a><span class="ln">   355</span>	            (progn
<a id="L356"></a><span class="ln">   356</span>	              (go--backward-irrelevant)
<a id="L357"></a><span class="ln">   357</span>	              (if (not (re-search-backward go-func-meth-regexp nil t))
<a id="L358"></a><span class="ln">   358</span>	                  (setq failure t)))
<a id="L359"></a><span class="ln">   359</span>	          (if (looking-at go-func-meth-regexp)
<a id="L360"></a><span class="ln">   360</span>	              (forward-char))
<a id="L361"></a><span class="ln">   361</span>	          (if (not (re-search-forward go-func-meth-regexp nil t))
<a id="L362"></a><span class="ln">   362</span>	              (setq failure t)))
<a id="L363"></a><span class="ln">   363</span>	        (setq first nil)))
<a id="L364"></a><span class="ln">   364</span>	    (if (&lt; count 0)
<a id="L365"></a><span class="ln">   365</span>	        (beginning-of-line))
<a id="L366"></a><span class="ln">   366</span>	    (not failure)))
<a id="L367"></a><span class="ln">   367</span>	
<a id="L368"></a><span class="ln">   368</span>	(defun go-end-of-defun ()
<a id="L369"></a><span class="ln">   369</span>	  (let (orig-level)
<a id="L370"></a><span class="ln">   370</span>	    ;; It can happen that we&#39;re not placed before a function by emacs
<a id="L371"></a><span class="ln">   371</span>	    (if (not (looking-at &#34;func&#34;))
<a id="L372"></a><span class="ln">   372</span>	        (go-beginning-of-defun -1))
<a id="L373"></a><span class="ln">   373</span>	    (skip-chars-forward &#34;^{&#34;)
<a id="L374"></a><span class="ln">   374</span>	    (forward-char)
<a id="L375"></a><span class="ln">   375</span>	    (setq orig-level (go-paren-level))
<a id="L376"></a><span class="ln">   376</span>	    (while (&gt;= (go-paren-level) orig-level)
<a id="L377"></a><span class="ln">   377</span>	      (skip-chars-forward &#34;^}&#34;)
<a id="L378"></a><span class="ln">   378</span>	      (forward-char))))
<a id="L379"></a><span class="ln">   379</span>	
<a id="L380"></a><span class="ln">   380</span>	;;;###autoload
<a id="L381"></a><span class="ln">   381</span>	(define-derived-mode go-mode prog-mode &#34;Go&#34;
<a id="L382"></a><span class="ln">   382</span>	  &#34;Major mode for editing Go source text.
<a id="L383"></a><span class="ln">   383</span>	
<a id="L384"></a><span class="ln">   384</span>	This mode provides (not just) basic editing capabilities for
<a id="L385"></a><span class="ln">   385</span>	working with Go code. It offers almost complete syntax
<a id="L386"></a><span class="ln">   386</span>	highlighting, indentation that is almost identical to gofmt and
<a id="L387"></a><span class="ln">   387</span>	proper parsing of the buffer content to allow features such as
<a id="L388"></a><span class="ln">   388</span>	navigation by function, manipulation of comments or detection of
<a id="L389"></a><span class="ln">   389</span>	strings.
<a id="L390"></a><span class="ln">   390</span>	
<a id="L391"></a><span class="ln">   391</span>	In addition to these core features, it offers various features to
<a id="L392"></a><span class="ln">   392</span>	help with writing Go code. You can directly run buffer content
<a id="L393"></a><span class="ln">   393</span>	through gofmt, read godoc documentation from within Emacs, modify
<a id="L394"></a><span class="ln">   394</span>	and clean up the list of package imports or interact with the
<a id="L395"></a><span class="ln">   395</span>	Playground (uploading and downloading pastes).
<a id="L396"></a><span class="ln">   396</span>	
<a id="L397"></a><span class="ln">   397</span>	The following extra functions are defined:
<a id="L398"></a><span class="ln">   398</span>	
<a id="L399"></a><span class="ln">   399</span>	- `gofmt&#39;
<a id="L400"></a><span class="ln">   400</span>	- `godoc&#39;
<a id="L401"></a><span class="ln">   401</span>	- `go-import-add&#39;
<a id="L402"></a><span class="ln">   402</span>	- `go-remove-unused-imports&#39;
<a id="L403"></a><span class="ln">   403</span>	- `go-goto-imports&#39;
<a id="L404"></a><span class="ln">   404</span>	- `go-play-buffer&#39; and `go-play-region&#39;
<a id="L405"></a><span class="ln">   405</span>	- `go-download-play&#39;
<a id="L406"></a><span class="ln">   406</span>	- `godef-describe&#39; and `godef-jump&#39;
<a id="L407"></a><span class="ln">   407</span>	
<a id="L408"></a><span class="ln">   408</span>	If you want to automatically run `gofmt&#39; before saving a file,
<a id="L409"></a><span class="ln">   409</span>	add the following hook to your emacs configuration:
<a id="L410"></a><span class="ln">   410</span>	
<a id="L411"></a><span class="ln">   411</span>	\(add-hook &#39;before-save-hook &#39;gofmt-before-save)
<a id="L412"></a><span class="ln">   412</span>	
<a id="L413"></a><span class="ln">   413</span>	If you want to use `godef-jump&#39; instead of etags (or similar),
<a id="L414"></a><span class="ln">   414</span>	consider binding godef-jump to `M-.&#39;, which is the default key
<a id="L415"></a><span class="ln">   415</span>	for `find-tag&#39;:
<a id="L416"></a><span class="ln">   416</span>	
<a id="L417"></a><span class="ln">   417</span>	\(add-hook &#39;go-mode-hook (lambda ()
<a id="L418"></a><span class="ln">   418</span>	                          (local-set-key (kbd \&#34;M-.\&#34;) &#39;godef-jump)))
<a id="L419"></a><span class="ln">   419</span>	
<a id="L420"></a><span class="ln">   420</span>	Please note that godef is an external dependency. You can install
<a id="L421"></a><span class="ln">   421</span>	it with
<a id="L422"></a><span class="ln">   422</span>	
<a id="L423"></a><span class="ln">   423</span>	go get code.google.com/p/rog-go/exp/cmd/godef
<a id="L424"></a><span class="ln">   424</span>	
<a id="L425"></a><span class="ln">   425</span>	
<a id="L426"></a><span class="ln">   426</span>	If you&#39;re looking for even more integration with Go, namely
<a id="L427"></a><span class="ln">   427</span>	on-the-fly syntax checking, auto-completion and snippets, it is
<a id="L428"></a><span class="ln">   428</span>	recommended that you look at goflymake
<a id="L429"></a><span class="ln">   429</span>	\(https://github.com/dougm/goflymake), gocode
<a id="L430"></a><span class="ln">   430</span>	\(https://github.com/nsf/gocode) and yasnippet-go
<a id="L431"></a><span class="ln">   431</span>	\(https://github.com/dominikh/yasnippet-go)&#34;
<a id="L432"></a><span class="ln">   432</span>	
<a id="L433"></a><span class="ln">   433</span>	  ;; Font lock
<a id="L434"></a><span class="ln">   434</span>	  (set (make-local-variable &#39;font-lock-defaults)
<a id="L435"></a><span class="ln">   435</span>	       &#39;(go--build-font-lock-keywords))
<a id="L436"></a><span class="ln">   436</span>	
<a id="L437"></a><span class="ln">   437</span>	  ;; Indentation
<a id="L438"></a><span class="ln">   438</span>	  (set (make-local-variable &#39;indent-line-function) &#39;go-mode-indent-line)
<a id="L439"></a><span class="ln">   439</span>	
<a id="L440"></a><span class="ln">   440</span>	  ;; Comments
<a id="L441"></a><span class="ln">   441</span>	  (set (make-local-variable &#39;comment-start) &#34;// &#34;)
<a id="L442"></a><span class="ln">   442</span>	  (set (make-local-variable &#39;comment-end)   &#34;&#34;)
<a id="L443"></a><span class="ln">   443</span>	  (set (make-local-variable &#39;comment-use-syntax) t)
<a id="L444"></a><span class="ln">   444</span>	  (set (make-local-variable &#39;comment-start-skip) &#34;\\(//+\\|/\\*+\\)\\s *&#34;)
<a id="L445"></a><span class="ln">   445</span>	
<a id="L446"></a><span class="ln">   446</span>	  (set (make-local-variable &#39;beginning-of-defun-function) &#39;go-beginning-of-defun)
<a id="L447"></a><span class="ln">   447</span>	  (set (make-local-variable &#39;end-of-defun-function) &#39;go-end-of-defun)
<a id="L448"></a><span class="ln">   448</span>	
<a id="L449"></a><span class="ln">   449</span>	  (set (make-local-variable &#39;parse-sexp-lookup-properties) t)
<a id="L450"></a><span class="ln">   450</span>	  (if (boundp &#39;syntax-propertize-function)
<a id="L451"></a><span class="ln">   451</span>	      (set (make-local-variable &#39;syntax-propertize-function) &#39;go-propertize-syntax))
<a id="L452"></a><span class="ln">   452</span>	
<a id="L453"></a><span class="ln">   453</span>	  (set (make-local-variable &#39;go-dangling-cache) (make-hash-table :test &#39;eql))
<a id="L454"></a><span class="ln">   454</span>	  (add-hook &#39;before-change-functions (lambda (x y) (setq go-dangling-cache (make-hash-table :test &#39;eql))) t t)
<a id="L455"></a><span class="ln">   455</span>	
<a id="L456"></a><span class="ln">   456</span>	
<a id="L457"></a><span class="ln">   457</span>	  (setq imenu-generic-expression
<a id="L458"></a><span class="ln">   458</span>	        &#39;((&#34;type&#34; &#34;^type *\\([^ \t\n\r\f]*\\)&#34; 1)
<a id="L459"></a><span class="ln">   459</span>	          (&#34;func&#34; &#34;^func *\\(.*\\) {&#34; 1)))
<a id="L460"></a><span class="ln">   460</span>	  (imenu-add-to-menubar &#34;Index&#34;)
<a id="L461"></a><span class="ln">   461</span>	
<a id="L462"></a><span class="ln">   462</span>	  ;; Go style
<a id="L463"></a><span class="ln">   463</span>	  (setq indent-tabs-mode t)
<a id="L464"></a><span class="ln">   464</span>	
<a id="L465"></a><span class="ln">   465</span>	  ;; Handle unit test failure output in compilation-mode
<a id="L466"></a><span class="ln">   466</span>	  ;;
<a id="L467"></a><span class="ln">   467</span>	  ;; Note the final t argument to add-to-list for append, ie put these at the
<a id="L468"></a><span class="ln">   468</span>	  ;; *ends* of compilation-error-regexp-alist[-alist]. We want go-test to be
<a id="L469"></a><span class="ln">   469</span>	  ;; handled first, otherwise other elements will match that don&#39;t work, and
<a id="L470"></a><span class="ln">   470</span>	  ;; those alists are traversed in *reverse* order:
<a id="L471"></a><span class="ln">   471</span>	  ;; http://lists.gnu.org/archive/html/bug-gnu-emacs/2001-12/msg00674.html
<a id="L472"></a><span class="ln">   472</span>	  (when (and (boundp &#39;compilation-error-regexp-alist)
<a id="L473"></a><span class="ln">   473</span>	             (boundp &#39;compilation-error-regexp-alist-alist))
<a id="L474"></a><span class="ln">   474</span>	    (add-to-list &#39;compilation-error-regexp-alist &#39;go-test t)
<a id="L475"></a><span class="ln">   475</span>	    (add-to-list &#39;compilation-error-regexp-alist-alist
<a id="L476"></a><span class="ln">   476</span>	                 &#39;(go-test . (&#34;^\t+\\([^()\t\n]+\\):\\([0-9]+\\):? .*$&#34; 1 2)) t)))
<a id="L477"></a><span class="ln">   477</span>	
<a id="L478"></a><span class="ln">   478</span>	;;;###autoload
<a id="L479"></a><span class="ln">   479</span>	(add-to-list &#39;auto-mode-alist (cons &#34;\\.go\\&#39;&#34; &#39;go-mode))
<a id="L480"></a><span class="ln">   480</span>	
<a id="L481"></a><span class="ln">   481</span>	(defun go--apply-rcs-patch (patch-buffer)
<a id="L482"></a><span class="ln">   482</span>	  &#34;Apply an RCS-formatted diff from PATCH-BUFFER to the current
<a id="L483"></a><span class="ln">   483</span>	buffer.&#34;
<a id="L484"></a><span class="ln">   484</span>	  (let ((target-buffer (current-buffer))
<a id="L485"></a><span class="ln">   485</span>	        ;; Relative offset between buffer line numbers and line numbers
<a id="L486"></a><span class="ln">   486</span>	        ;; in patch.
<a id="L487"></a><span class="ln">   487</span>	        ;;
<a id="L488"></a><span class="ln">   488</span>	        ;; Line numbers in the patch are based on the source file, so
<a id="L489"></a><span class="ln">   489</span>	        ;; we have to keep an offset when making changes to the
<a id="L490"></a><span class="ln">   490</span>	        ;; buffer.
<a id="L491"></a><span class="ln">   491</span>	        ;;
<a id="L492"></a><span class="ln">   492</span>	        ;; Appending lines decrements the offset (possibly making it
<a id="L493"></a><span class="ln">   493</span>	        ;; negative), deleting lines increments it. This order
<a id="L494"></a><span class="ln">   494</span>	        ;; simplifies the forward-line invocations.
<a id="L495"></a><span class="ln">   495</span>	        (line-offset 0))
<a id="L496"></a><span class="ln">   496</span>	    (save-excursion
<a id="L497"></a><span class="ln">   497</span>	      (with-current-buffer patch-buffer
<a id="L498"></a><span class="ln">   498</span>	        (goto-char (point-min))
<a id="L499"></a><span class="ln">   499</span>	        (while (not (eobp))
<a id="L500"></a><span class="ln">   500</span>	          (unless (looking-at &#34;^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)&#34;)
<a id="L501"></a><span class="ln">   501</span>	            (error &#34;invalid rcs patch or internal error in go--apply-rcs-patch&#34;))
<a id="L502"></a><span class="ln">   502</span>	          (forward-line)
<a id="L503"></a><span class="ln">   503</span>	          (let ((action (match-string 1))
<a id="L504"></a><span class="ln">   504</span>	                (from (string-to-number (match-string 2)))
<a id="L505"></a><span class="ln">   505</span>	                (len  (string-to-number (match-string 3))))
<a id="L506"></a><span class="ln">   506</span>	            (cond
<a id="L507"></a><span class="ln">   507</span>	             ((equal action &#34;a&#34;)
<a id="L508"></a><span class="ln">   508</span>	              (let ((start (point)))
<a id="L509"></a><span class="ln">   509</span>	                (forward-line len)
<a id="L510"></a><span class="ln">   510</span>	                (let ((text (buffer-substring start (point))))
<a id="L511"></a><span class="ln">   511</span>	                  (with-current-buffer target-buffer
<a id="L512"></a><span class="ln">   512</span>	                    (decf line-offset len)
<a id="L513"></a><span class="ln">   513</span>	                    (goto-char (point-min))
<a id="L514"></a><span class="ln">   514</span>	                    (forward-line (- from len line-offset))
<a id="L515"></a><span class="ln">   515</span>	                    (insert text)))))
<a id="L516"></a><span class="ln">   516</span>	             ((equal action &#34;d&#34;)
<a id="L517"></a><span class="ln">   517</span>	              (with-current-buffer target-buffer
<a id="L518"></a><span class="ln">   518</span>	                (goto-char (point-min))
<a id="L519"></a><span class="ln">   519</span>	                (forward-line (- from line-offset 1))
<a id="L520"></a><span class="ln">   520</span>	                (incf line-offset len)
<a id="L521"></a><span class="ln">   521</span>	                (go--kill-whole-line len)))
<a id="L522"></a><span class="ln">   522</span>	             (t
<a id="L523"></a><span class="ln">   523</span>	              (error &#34;invalid rcs patch or internal error in go--apply-rcs-patch&#34;)))))))))
<a id="L524"></a><span class="ln">   524</span>	
<a id="L525"></a><span class="ln">   525</span>	(defun gofmt ()
<a id="L526"></a><span class="ln">   526</span>	  &#34;Formats the current buffer according to the gofmt tool.&#34;
<a id="L527"></a><span class="ln">   527</span>	
<a id="L528"></a><span class="ln">   528</span>	  (interactive)
<a id="L529"></a><span class="ln">   529</span>	  (let ((tmpfile (make-temp-file &#34;gofmt&#34; nil &#34;.go&#34;))
<a id="L530"></a><span class="ln">   530</span>	        (patchbuf (get-buffer-create &#34;*Gofmt patch*&#34;))
<a id="L531"></a><span class="ln">   531</span>	        (errbuf (get-buffer-create &#34;*Gofmt Errors*&#34;))
<a id="L532"></a><span class="ln">   532</span>	        (coding-system-for-read &#39;utf-8)
<a id="L533"></a><span class="ln">   533</span>	        (coding-system-for-write &#39;utf-8))
<a id="L534"></a><span class="ln">   534</span>	
<a id="L535"></a><span class="ln">   535</span>	    (with-current-buffer errbuf
<a id="L536"></a><span class="ln">   536</span>	      (setq buffer-read-only nil)
<a id="L537"></a><span class="ln">   537</span>	      (erase-buffer))
<a id="L538"></a><span class="ln">   538</span>	    (with-current-buffer patchbuf
<a id="L539"></a><span class="ln">   539</span>	      (erase-buffer))
<a id="L540"></a><span class="ln">   540</span>	
<a id="L541"></a><span class="ln">   541</span>	    (write-region nil nil tmpfile)
<a id="L542"></a><span class="ln">   542</span>	
<a id="L543"></a><span class="ln">   543</span>	    ;; We&#39;re using errbuf for the mixed stdout and stderr output. This
<a id="L544"></a><span class="ln">   544</span>	    ;; is not an issue because gofmt -w does not produce any stdout
<a id="L545"></a><span class="ln">   545</span>	    ;; output in case of success.
<a id="L546"></a><span class="ln">   546</span>	    (if (zerop (call-process &#34;gofmt&#34; nil errbuf nil &#34;-w&#34; tmpfile))
<a id="L547"></a><span class="ln">   547</span>	        (if (zerop (call-process-region (point-min) (point-max) &#34;diff&#34; nil patchbuf nil &#34;-n&#34; &#34;-&#34; tmpfile))
<a id="L548"></a><span class="ln">   548</span>	            (progn
<a id="L549"></a><span class="ln">   549</span>	              (kill-buffer errbuf)
<a id="L550"></a><span class="ln">   550</span>	              (message &#34;Buffer is already gofmted&#34;))
<a id="L551"></a><span class="ln">   551</span>	          (go--apply-rcs-patch patchbuf)
<a id="L552"></a><span class="ln">   552</span>	          (kill-buffer errbuf)
<a id="L553"></a><span class="ln">   553</span>	          (message &#34;Applied gofmt&#34;))
<a id="L554"></a><span class="ln">   554</span>	      (message &#34;Could not apply gofmt. Check errors for details&#34;)
<a id="L555"></a><span class="ln">   555</span>	      (gofmt--process-errors (buffer-file-name) tmpfile errbuf))
<a id="L556"></a><span class="ln">   556</span>	
<a id="L557"></a><span class="ln">   557</span>	    (kill-buffer patchbuf)
<a id="L558"></a><span class="ln">   558</span>	    (delete-file tmpfile)))
<a id="L559"></a><span class="ln">   559</span>	
<a id="L560"></a><span class="ln">   560</span>	
<a id="L561"></a><span class="ln">   561</span>	(defun gofmt--process-errors (filename tmpfile errbuf)
<a id="L562"></a><span class="ln">   562</span>	  ;; Convert the gofmt stderr to something understood by the compilation mode.
<a id="L563"></a><span class="ln">   563</span>	  (with-current-buffer errbuf
<a id="L564"></a><span class="ln">   564</span>	    (goto-char (point-min))
<a id="L565"></a><span class="ln">   565</span>	    (insert &#34;gofmt errors:\n&#34;)
<a id="L566"></a><span class="ln">   566</span>	    (while (search-forward-regexp (concat &#34;^\\(&#34; (regexp-quote tmpfile) &#34;\\):&#34;) nil t)
<a id="L567"></a><span class="ln">   567</span>	      (replace-match (file-name-nondirectory filename) t t nil 1))
<a id="L568"></a><span class="ln">   568</span>	    (compilation-mode)
<a id="L569"></a><span class="ln">   569</span>	    (display-buffer errbuf)))
<a id="L570"></a><span class="ln">   570</span>	
<a id="L571"></a><span class="ln">   571</span>	;;;###autoload
<a id="L572"></a><span class="ln">   572</span>	(defun gofmt-before-save ()
<a id="L573"></a><span class="ln">   573</span>	  &#34;Add this to .emacs to run gofmt on the current buffer when saving:
<a id="L574"></a><span class="ln">   574</span>	 (add-hook &#39;before-save-hook &#39;gofmt-before-save).
<a id="L575"></a><span class="ln">   575</span>	
<a id="L576"></a><span class="ln">   576</span>	Note that this will cause go-mode to get loaded the first time
<a id="L577"></a><span class="ln">   577</span>	you save any file, kind of defeating the point of autoloading.&#34;
<a id="L578"></a><span class="ln">   578</span>	
<a id="L579"></a><span class="ln">   579</span>	  (interactive)
<a id="L580"></a><span class="ln">   580</span>	  (when (eq major-mode &#39;go-mode) (gofmt)))
<a id="L581"></a><span class="ln">   581</span>	
<a id="L582"></a><span class="ln">   582</span>	(defun godoc--read-query ()
<a id="L583"></a><span class="ln">   583</span>	  &#34;Read a godoc query from the minibuffer.&#34;
<a id="L584"></a><span class="ln">   584</span>	  ;; Compute the default query as the symbol under the cursor.
<a id="L585"></a><span class="ln">   585</span>	  ;; TODO: This does the wrong thing for e.g. multipart.NewReader (it only grabs
<a id="L586"></a><span class="ln">   586</span>	  ;; half) but I see no way to disambiguate that from e.g. foobar.SomeMethod.
<a id="L587"></a><span class="ln">   587</span>	  (let* ((bounds (bounds-of-thing-at-point &#39;symbol))
<a id="L588"></a><span class="ln">   588</span>	         (symbol (if bounds
<a id="L589"></a><span class="ln">   589</span>	                     (buffer-substring-no-properties (car bounds)
<a id="L590"></a><span class="ln">   590</span>	                                                     (cdr bounds)))))
<a id="L591"></a><span class="ln">   591</span>	    (completing-read (if symbol
<a id="L592"></a><span class="ln">   592</span>	                         (format &#34;godoc (default %s): &#34; symbol)
<a id="L593"></a><span class="ln">   593</span>	                       &#34;godoc: &#34;)
<a id="L594"></a><span class="ln">   594</span>	                     (go--old-completion-list-style (go-packages)) nil nil nil &#39;go-godoc-history symbol)))
<a id="L595"></a><span class="ln">   595</span>	
<a id="L596"></a><span class="ln">   596</span>	(defun godoc--get-buffer (query)
<a id="L597"></a><span class="ln">   597</span>	  &#34;Get an empty buffer for a godoc query.&#34;
<a id="L598"></a><span class="ln">   598</span>	  (let* ((buffer-name (concat &#34;*godoc &#34; query &#34;*&#34;))
<a id="L599"></a><span class="ln">   599</span>	         (buffer (get-buffer buffer-name)))
<a id="L600"></a><span class="ln">   600</span>	    ;; Kill the existing buffer if it already exists.
<a id="L601"></a><span class="ln">   601</span>	    (when buffer (kill-buffer buffer))
<a id="L602"></a><span class="ln">   602</span>	    (get-buffer-create buffer-name)))
<a id="L603"></a><span class="ln">   603</span>	
<a id="L604"></a><span class="ln">   604</span>	(defun godoc--buffer-sentinel (proc event)
<a id="L605"></a><span class="ln">   605</span>	  &#34;Sentinel function run when godoc command completes.&#34;
<a id="L606"></a><span class="ln">   606</span>	  (with-current-buffer (process-buffer proc)
<a id="L607"></a><span class="ln">   607</span>	    (cond ((string= event &#34;finished\n&#34;)  ;; Successful exit.
<a id="L608"></a><span class="ln">   608</span>	           (goto-char (point-min))
<a id="L609"></a><span class="ln">   609</span>	           (view-mode 1)
<a id="L610"></a><span class="ln">   610</span>	           (display-buffer (current-buffer) t))
<a id="L611"></a><span class="ln">   611</span>	          ((/= (process-exit-status proc) 0)  ;; Error exit.
<a id="L612"></a><span class="ln">   612</span>	           (let ((output (buffer-string)))
<a id="L613"></a><span class="ln">   613</span>	             (kill-buffer (current-buffer))
<a id="L614"></a><span class="ln">   614</span>	             (message (concat &#34;godoc: &#34; output)))))))
<a id="L615"></a><span class="ln">   615</span>	
<a id="L616"></a><span class="ln">   616</span>	;;;###autoload
<a id="L617"></a><span class="ln">   617</span>	(defun godoc (query)
<a id="L618"></a><span class="ln">   618</span>	  &#34;Show go documentation for a query, much like M-x man.&#34;
<a id="L619"></a><span class="ln">   619</span>	  (interactive (list (godoc--read-query)))
<a id="L620"></a><span class="ln">   620</span>	  (unless (string= query &#34;&#34;)
<a id="L621"></a><span class="ln">   621</span>	    (set-process-sentinel
<a id="L622"></a><span class="ln">   622</span>	     (start-process-shell-command &#34;godoc&#34; (godoc--get-buffer query)
<a id="L623"></a><span class="ln">   623</span>	                                  (concat &#34;godoc &#34; query))
<a id="L624"></a><span class="ln">   624</span>	     &#39;godoc--buffer-sentinel)
<a id="L625"></a><span class="ln">   625</span>	    nil))
<a id="L626"></a><span class="ln">   626</span>	
<a id="L627"></a><span class="ln">   627</span>	(defun go-goto-imports ()
<a id="L628"></a><span class="ln">   628</span>	  &#34;Move point to the block of imports.
<a id="L629"></a><span class="ln">   629</span>	
<a id="L630"></a><span class="ln">   630</span>	If using
<a id="L631"></a><span class="ln">   631</span>	
<a id="L632"></a><span class="ln">   632</span>	  import (
<a id="L633"></a><span class="ln">   633</span>	    \&#34;foo\&#34;
<a id="L634"></a><span class="ln">   634</span>	    \&#34;bar\&#34;
<a id="L635"></a><span class="ln">   635</span>	  )
<a id="L636"></a><span class="ln">   636</span>	
<a id="L637"></a><span class="ln">   637</span>	it will move point directly behind the last import.
<a id="L638"></a><span class="ln">   638</span>	
<a id="L639"></a><span class="ln">   639</span>	If using
<a id="L640"></a><span class="ln">   640</span>	
<a id="L641"></a><span class="ln">   641</span>	  import \&#34;foo\&#34;
<a id="L642"></a><span class="ln">   642</span>	  import \&#34;bar\&#34;
<a id="L643"></a><span class="ln">   643</span>	
<a id="L644"></a><span class="ln">   644</span>	it will move point to the next line after the last import.
<a id="L645"></a><span class="ln">   645</span>	
<a id="L646"></a><span class="ln">   646</span>	If no imports can be found, point will be moved after the package
<a id="L647"></a><span class="ln">   647</span>	declaration.&#34;
<a id="L648"></a><span class="ln">   648</span>	  (interactive)
<a id="L649"></a><span class="ln">   649</span>	  ;; FIXME if there&#39;s a block-commented import before the real
<a id="L650"></a><span class="ln">   650</span>	  ;; imports, we&#39;ll jump to that one.
<a id="L651"></a><span class="ln">   651</span>	
<a id="L652"></a><span class="ln">   652</span>	  ;; Generally, this function isn&#39;t very forgiving. it&#39;ll bark on
<a id="L653"></a><span class="ln">   653</span>	  ;; extra whitespace. It works well for clean code.
<a id="L654"></a><span class="ln">   654</span>	  (let ((old-point (point)))
<a id="L655"></a><span class="ln">   655</span>	    (goto-char (point-min))
<a id="L656"></a><span class="ln">   656</span>	    (cond
<a id="L657"></a><span class="ln">   657</span>	     ((re-search-forward &#34;^import ([^)]+)&#34; nil t)
<a id="L658"></a><span class="ln">   658</span>	      (backward-char 2)
<a id="L659"></a><span class="ln">   659</span>	      &#39;block)
<a id="L660"></a><span class="ln">   660</span>	     ((re-search-forward &#34;\\(^import \\([^\&#34;]+ \\)?\&#34;[^\&#34;]+\&#34;\n?\\)+&#34; nil t)
<a id="L661"></a><span class="ln">   661</span>	      &#39;single)
<a id="L662"></a><span class="ln">   662</span>	     ((re-search-forward &#34;^[[:space:]\n]*package .+?\n&#34; nil t)
<a id="L663"></a><span class="ln">   663</span>	      (message &#34;No imports found, moving point after package declaration&#34;)
<a id="L664"></a><span class="ln">   664</span>	      &#39;none)
<a id="L665"></a><span class="ln">   665</span>	     (t
<a id="L666"></a><span class="ln">   666</span>	      (goto-char old-point)
<a id="L667"></a><span class="ln">   667</span>	      (message &#34;No imports or package declaration found. Is this really a Go file?&#34;)
<a id="L668"></a><span class="ln">   668</span>	      &#39;fail))))
<a id="L669"></a><span class="ln">   669</span>	
<a id="L670"></a><span class="ln">   670</span>	(defun go-play-buffer ()
<a id="L671"></a><span class="ln">   671</span>	  &#34;Like `go-play-region&#39;, but acts on the entire buffer.&#34;
<a id="L672"></a><span class="ln">   672</span>	  (interactive)
<a id="L673"></a><span class="ln">   673</span>	  (go-play-region (point-min) (point-max)))
<a id="L674"></a><span class="ln">   674</span>	
<a id="L675"></a><span class="ln">   675</span>	(defun go-play-region (start end)
<a id="L676"></a><span class="ln">   676</span>	  &#34;Send the region to the Playground and stores the resulting
<a id="L677"></a><span class="ln">   677</span>	link in the kill ring.&#34;
<a id="L678"></a><span class="ln">   678</span>	  (interactive &#34;r&#34;)
<a id="L679"></a><span class="ln">   679</span>	  (let* ((url-request-method &#34;POST&#34;)
<a id="L680"></a><span class="ln">   680</span>	         (url-request-extra-headers
<a id="L681"></a><span class="ln">   681</span>	          &#39;((&#34;Content-Type&#34; . &#34;application/x-www-form-urlencoded&#34;)))
<a id="L682"></a><span class="ln">   682</span>	         (url-request-data (buffer-substring-no-properties start end))
<a id="L683"></a><span class="ln">   683</span>	         (content-buf (url-retrieve
<a id="L684"></a><span class="ln">   684</span>	                       &#34;http://play.golang.org/share&#34;
<a id="L685"></a><span class="ln">   685</span>	                       (lambda (arg)
<a id="L686"></a><span class="ln">   686</span>	                         (cond
<a id="L687"></a><span class="ln">   687</span>	                          ((equal :error (car arg))
<a id="L688"></a><span class="ln">   688</span>	                           (signal &#39;go-play-error (cdr arg)))
<a id="L689"></a><span class="ln">   689</span>	                          (t
<a id="L690"></a><span class="ln">   690</span>	                           (re-search-forward &#34;\n\n&#34;)
<a id="L691"></a><span class="ln">   691</span>	                           (kill-new (format &#34;http://play.golang.org/p/%s&#34; (buffer-substring (point) (point-max))))
<a id="L692"></a><span class="ln">   692</span>	                           (message &#34;http://play.golang.org/p/%s&#34; (buffer-substring (point) (point-max)))))))))))
<a id="L693"></a><span class="ln">   693</span>	
<a id="L694"></a><span class="ln">   694</span>	;;;###autoload
<a id="L695"></a><span class="ln">   695</span>	(defun go-download-play (url)
<a id="L696"></a><span class="ln">   696</span>	  &#34;Downloads a paste from the playground and inserts it in a Go
<a id="L697"></a><span class="ln">   697</span>	buffer. Tries to look for a URL at point.&#34;
<a id="L698"></a><span class="ln">   698</span>	  (interactive (list (read-from-minibuffer &#34;Playground URL: &#34; (ffap-url-p (ffap-string-at-point &#39;url)))))
<a id="L699"></a><span class="ln">   699</span>	  (with-current-buffer
<a id="L700"></a><span class="ln">   700</span>	      (let ((url-request-method &#34;GET&#34;) url-request-data url-request-extra-headers)
<a id="L701"></a><span class="ln">   701</span>	        (url-retrieve-synchronously (concat url &#34;.go&#34;)))
<a id="L702"></a><span class="ln">   702</span>	    (let ((buffer (generate-new-buffer (concat (car (last (split-string url &#34;/&#34;))) &#34;.go&#34;))))
<a id="L703"></a><span class="ln">   703</span>	      (goto-char (point-min))
<a id="L704"></a><span class="ln">   704</span>	      (re-search-forward &#34;\n\n&#34;)
<a id="L705"></a><span class="ln">   705</span>	      (copy-to-buffer buffer (point) (point-max))
<a id="L706"></a><span class="ln">   706</span>	      (kill-buffer)
<a id="L707"></a><span class="ln">   707</span>	      (with-current-buffer buffer
<a id="L708"></a><span class="ln">   708</span>	        (go-mode)
<a id="L709"></a><span class="ln">   709</span>	        (switch-to-buffer buffer)))))
<a id="L710"></a><span class="ln">   710</span>	
<a id="L711"></a><span class="ln">   711</span>	(defun go-propertize-syntax (start end)
<a id="L712"></a><span class="ln">   712</span>	  (save-excursion
<a id="L713"></a><span class="ln">   713</span>	    (goto-char start)
<a id="L714"></a><span class="ln">   714</span>	    (while (search-forward &#34;\\&#34; end t)
<a id="L715"></a><span class="ln">   715</span>	      (put-text-property (1- (point)) (point) &#39;syntax-table (if (= (char-after) ?`) &#39;(1) &#39;(9))))))
<a id="L716"></a><span class="ln">   716</span>	
<a id="L717"></a><span class="ln">   717</span>	;; ;; Commented until we actually make use of this function
<a id="L718"></a><span class="ln">   718</span>	;; (defun go--common-prefix (sequences)
<a id="L719"></a><span class="ln">   719</span>	;;   ;; mismatch and reduce are cl
<a id="L720"></a><span class="ln">   720</span>	;;   (assert sequences)
<a id="L721"></a><span class="ln">   721</span>	;;   (flet ((common-prefix (s1 s2)
<a id="L722"></a><span class="ln">   722</span>	;;                         (let ((diff-pos (mismatch s1 s2)))
<a id="L723"></a><span class="ln">   723</span>	;;                           (if diff-pos (subseq s1 0 diff-pos) s1))))
<a id="L724"></a><span class="ln">   724</span>	;;     (reduce #&#39;common-prefix sequences)))
<a id="L725"></a><span class="ln">   725</span>	
<a id="L726"></a><span class="ln">   726</span>	(defun go-import-add (arg import)
<a id="L727"></a><span class="ln">   727</span>	  &#34;Add a new import to the list of imports.
<a id="L728"></a><span class="ln">   728</span>	
<a id="L729"></a><span class="ln">   729</span>	When called with a prefix argument asks for an alternative name
<a id="L730"></a><span class="ln">   730</span>	to import the package as.
<a id="L731"></a><span class="ln">   731</span>	
<a id="L732"></a><span class="ln">   732</span>	If no list exists yet, one will be created if possible.
<a id="L733"></a><span class="ln">   733</span>	
<a id="L734"></a><span class="ln">   734</span>	If an identical import has been commented, it will be
<a id="L735"></a><span class="ln">   735</span>	uncommented, otherwise a new import will be added.&#34;
<a id="L736"></a><span class="ln">   736</span>	
<a id="L737"></a><span class="ln">   737</span>	  ;; - If there&#39;s a matching `// import &#34;foo&#34;`, uncomment it
<a id="L738"></a><span class="ln">   738</span>	  ;; - If we&#39;re in an import() block and there&#39;s a matching `&#34;foo&#34;`, uncomment it
<a id="L739"></a><span class="ln">   739</span>	  ;; - Otherwise add a new import, with the appropriate syntax
<a id="L740"></a><span class="ln">   740</span>	  (interactive
<a id="L741"></a><span class="ln">   741</span>	   (list
<a id="L742"></a><span class="ln">   742</span>	    current-prefix-arg
<a id="L743"></a><span class="ln">   743</span>	    (replace-regexp-in-string &#34;^[\&#34;&#39;]\\|[\&#34;&#39;]$&#34; &#34;&#34; (completing-read &#34;Package: &#34; (go--old-completion-list-style (go-packages))))))
<a id="L744"></a><span class="ln">   744</span>	  (save-excursion
<a id="L745"></a><span class="ln">   745</span>	    (let (as line import-start)
<a id="L746"></a><span class="ln">   746</span>	      (if arg
<a id="L747"></a><span class="ln">   747</span>	          (setq as (read-from-minibuffer &#34;Import as: &#34;)))
<a id="L748"></a><span class="ln">   748</span>	      (if as
<a id="L749"></a><span class="ln">   749</span>	          (setq line (format &#34;%s \&#34;%s\&#34;&#34; as import))
<a id="L750"></a><span class="ln">   750</span>	        (setq line (format &#34;\&#34;%s\&#34;&#34; import)))
<a id="L751"></a><span class="ln">   751</span>	
<a id="L752"></a><span class="ln">   752</span>	      (goto-char (point-min))
<a id="L753"></a><span class="ln">   753</span>	      (if (re-search-forward (concat &#34;^[[:space:]]*//[[:space:]]*import &#34; line &#34;$&#34;) nil t)
<a id="L754"></a><span class="ln">   754</span>	          (uncomment-region (line-beginning-position) (line-end-position))
<a id="L755"></a><span class="ln">   755</span>	        (case (go-goto-imports)
<a id="L756"></a><span class="ln">   756</span>	          (&#39;fail (message &#34;Could not find a place to add import.&#34;))
<a id="L757"></a><span class="ln">   757</span>	          (&#39;block
<a id="L758"></a><span class="ln">   758</span>	              (save-excursion
<a id="L759"></a><span class="ln">   759</span>	                (re-search-backward &#34;^import (&#34;)
<a id="L760"></a><span class="ln">   760</span>	                (setq import-start (point)))
<a id="L761"></a><span class="ln">   761</span>	            (if (re-search-backward (concat &#34;^[[:space:]]*//[[:space:]]*&#34; line &#34;$&#34;)  import-start t)
<a id="L762"></a><span class="ln">   762</span>	                (uncomment-region (line-beginning-position) (line-end-position))
<a id="L763"></a><span class="ln">   763</span>	              (insert &#34;\n\t&#34; line)))
<a id="L764"></a><span class="ln">   764</span>	          (&#39;single (insert &#34;import &#34; line &#34;\n&#34;))
<a id="L765"></a><span class="ln">   765</span>	          (&#39;none (insert &#34;\nimport (\n\t&#34; line &#34;\n)\n&#34;)))))))
<a id="L766"></a><span class="ln">   766</span>	
<a id="L767"></a><span class="ln">   767</span>	(defun go-root-and-paths ()
<a id="L768"></a><span class="ln">   768</span>	  (let* ((output (split-string (shell-command-to-string &#34;go env GOROOT GOPATH&#34;) &#34;\n&#34;))
<a id="L769"></a><span class="ln">   769</span>	         (root (car output))
<a id="L770"></a><span class="ln">   770</span>	         (paths (split-string (cadr output) &#34;:&#34;)))
<a id="L771"></a><span class="ln">   771</span>	    (append (list root) paths)))
<a id="L772"></a><span class="ln">   772</span>	
<a id="L773"></a><span class="ln">   773</span>	(defun go--string-prefix-p (s1 s2 &amp;optional ignore-case)
<a id="L774"></a><span class="ln">   774</span>	  &#34;Return non-nil if S1 is a prefix of S2.
<a id="L775"></a><span class="ln">   775</span>	If IGNORE-CASE is non-nil, the comparison is case-insensitive.&#34;
<a id="L776"></a><span class="ln">   776</span>	  (eq t (compare-strings s1 nil nil
<a id="L777"></a><span class="ln">   777</span>	                         s2 0 (length s1) ignore-case)))
<a id="L778"></a><span class="ln">   778</span>	
<a id="L779"></a><span class="ln">   779</span>	(defun go--directory-dirs (dir)
<a id="L780"></a><span class="ln">   780</span>	  &#34;Recursively return all subdirectories in DIR.&#34;
<a id="L781"></a><span class="ln">   781</span>	  (if (file-directory-p dir)
<a id="L782"></a><span class="ln">   782</span>	      (let ((dir (directory-file-name dir))
<a id="L783"></a><span class="ln">   783</span>	            (dirs &#39;())
<a id="L784"></a><span class="ln">   784</span>	            (files (directory-files dir nil nil t)))
<a id="L785"></a><span class="ln">   785</span>	        (dolist (file files)
<a id="L786"></a><span class="ln">   786</span>	          (unless (member file &#39;(&#34;.&#34; &#34;..&#34;))
<a id="L787"></a><span class="ln">   787</span>	            (let ((file (concat dir &#34;/&#34; file)))
<a id="L788"></a><span class="ln">   788</span>	              (if (file-directory-p file)
<a id="L789"></a><span class="ln">   789</span>	                  (setq dirs (append (cons file
<a id="L790"></a><span class="ln">   790</span>	                                           (go--directory-dirs file))
<a id="L791"></a><span class="ln">   791</span>	                                     dirs))))))
<a id="L792"></a><span class="ln">   792</span>	        dirs)
<a id="L793"></a><span class="ln">   793</span>	    &#39;()))
<a id="L794"></a><span class="ln">   794</span>	
<a id="L795"></a><span class="ln">   795</span>	
<a id="L796"></a><span class="ln">   796</span>	(defun go-packages ()
<a id="L797"></a><span class="ln">   797</span>	  (sort
<a id="L798"></a><span class="ln">   798</span>	   (delete-dups
<a id="L799"></a><span class="ln">   799</span>	    (mapcan
<a id="L800"></a><span class="ln">   800</span>	     (lambda (topdir)
<a id="L801"></a><span class="ln">   801</span>	       (let ((pkgdir (concat topdir &#34;/pkg/&#34;)))
<a id="L802"></a><span class="ln">   802</span>	         (mapcan (lambda (dir)
<a id="L803"></a><span class="ln">   803</span>	                   (mapcar (lambda (file)
<a id="L804"></a><span class="ln">   804</span>	                             (let ((sub (substring file (length pkgdir) -2)))
<a id="L805"></a><span class="ln">   805</span>	                               (unless (or (go--string-prefix-p &#34;obj/&#34; sub) (go--string-prefix-p &#34;tool/&#34; sub))
<a id="L806"></a><span class="ln">   806</span>	                                 (mapconcat &#39;identity (cdr (split-string sub &#34;/&#34;)) &#34;/&#34;))))
<a id="L807"></a><span class="ln">   807</span>	                           (if (file-directory-p dir)
<a id="L808"></a><span class="ln">   808</span>	                               (directory-files dir t &#34;\\.a$&#34;))))
<a id="L809"></a><span class="ln">   809</span>	                 (if (file-directory-p pkgdir)
<a id="L810"></a><span class="ln">   810</span>	                     (go--directory-dirs pkgdir)))))
<a id="L811"></a><span class="ln">   811</span>	     (go-root-and-paths)))
<a id="L812"></a><span class="ln">   812</span>	   &#39;string&lt;))
<a id="L813"></a><span class="ln">   813</span>	
<a id="L814"></a><span class="ln">   814</span>	(defun go-unused-imports-lines ()
<a id="L815"></a><span class="ln">   815</span>	  ;; FIXME Technically, -o /dev/null fails in quite some cases (on
<a id="L816"></a><span class="ln">   816</span>	  ;; Windows, when compiling from within GOPATH). Practically,
<a id="L817"></a><span class="ln">   817</span>	  ;; however, it has the same end result: There won&#39;t be a
<a id="L818"></a><span class="ln">   818</span>	  ;; compiled binary/archive, and we&#39;ll get our import errors when
<a id="L819"></a><span class="ln">   819</span>	  ;; there are any.
<a id="L820"></a><span class="ln">   820</span>	  (reverse (remove nil
<a id="L821"></a><span class="ln">   821</span>	                   (mapcar
<a id="L822"></a><span class="ln">   822</span>	                    (lambda (line)
<a id="L823"></a><span class="ln">   823</span>	                      (if (string-match &#34;^\\(.+\\):\\([[:digit:]]+\\): imported and not used: \&#34;.+\&#34;$&#34; line)
<a id="L824"></a><span class="ln">   824</span>	                          (if (string= (file-truename (match-string 1 line)) (file-truename buffer-file-name))
<a id="L825"></a><span class="ln">   825</span>	                              (string-to-number (match-string 2 line)))))
<a id="L826"></a><span class="ln">   826</span>	                    (split-string (shell-command-to-string
<a id="L827"></a><span class="ln">   827</span>	                                   (if (string-match &#34;_test\.go$&#34; buffer-file-truename)
<a id="L828"></a><span class="ln">   828</span>	                                       &#34;go test -c&#34;
<a id="L829"></a><span class="ln">   829</span>	                                     &#34;go build -o /dev/null&#34;)) &#34;\n&#34;)))))
<a id="L830"></a><span class="ln">   830</span>	
<a id="L831"></a><span class="ln">   831</span>	(defun go-remove-unused-imports (arg)
<a id="L832"></a><span class="ln">   832</span>	  &#34;Removes all unused imports. If ARG is non-nil, unused imports
<a id="L833"></a><span class="ln">   833</span>	will be commented, otherwise they will be removed completely.&#34;
<a id="L834"></a><span class="ln">   834</span>	  (interactive &#34;P&#34;)
<a id="L835"></a><span class="ln">   835</span>	  (save-excursion
<a id="L836"></a><span class="ln">   836</span>	    (let ((cur-buffer (current-buffer)) flymake-state lines)
<a id="L837"></a><span class="ln">   837</span>	      (when (boundp &#39;flymake-mode)
<a id="L838"></a><span class="ln">   838</span>	        (setq flymake-state flymake-mode)
<a id="L839"></a><span class="ln">   839</span>	        (flymake-mode-off))
<a id="L840"></a><span class="ln">   840</span>	      (save-some-buffers nil (lambda () (equal cur-buffer (current-buffer))))
<a id="L841"></a><span class="ln">   841</span>	      (if (buffer-modified-p)
<a id="L842"></a><span class="ln">   842</span>	          (message &#34;Cannot operate on unsaved buffer&#34;)
<a id="L843"></a><span class="ln">   843</span>	        (setq lines (go-unused-imports-lines))
<a id="L844"></a><span class="ln">   844</span>	        (dolist (import lines)
<a id="L845"></a><span class="ln">   845</span>	          (goto-char (point-min))
<a id="L846"></a><span class="ln">   846</span>	          (forward-line (1- import))
<a id="L847"></a><span class="ln">   847</span>	          (beginning-of-line)
<a id="L848"></a><span class="ln">   848</span>	          (if arg
<a id="L849"></a><span class="ln">   849</span>	              (comment-region (line-beginning-position) (line-end-position))
<a id="L850"></a><span class="ln">   850</span>	            (go--kill-whole-line)))
<a id="L851"></a><span class="ln">   851</span>	        (message &#34;Removed %d imports&#34; (length lines)))
<a id="L852"></a><span class="ln">   852</span>	      (if flymake-state (flymake-mode-on)))))
<a id="L853"></a><span class="ln">   853</span>	
<a id="L854"></a><span class="ln">   854</span>	(defun godef--find-file-line-column (specifier)
<a id="L855"></a><span class="ln">   855</span>	  &#34;Given a file name in the format of `filename:line:column&#39;,
<a id="L856"></a><span class="ln">   856</span>	visit FILENAME and go to line LINE and column COLUMN.&#34;
<a id="L857"></a><span class="ln">   857</span>	  (let* ((components (split-string specifier &#34;:&#34;))
<a id="L858"></a><span class="ln">   858</span>	         (line (string-to-number (nth 1 components)))
<a id="L859"></a><span class="ln">   859</span>	         (column (string-to-number (nth 2 components))))
<a id="L860"></a><span class="ln">   860</span>	    (with-current-buffer (find-file (car components))
<a id="L861"></a><span class="ln">   861</span>	      (goto-char (point-min))
<a id="L862"></a><span class="ln">   862</span>	      (forward-line (1- line))
<a id="L863"></a><span class="ln">   863</span>	      (beginning-of-line)
<a id="L864"></a><span class="ln">   864</span>	      (forward-char (1- column))
<a id="L865"></a><span class="ln">   865</span>	      (if (buffer-modified-p)
<a id="L866"></a><span class="ln">   866</span>	          (message &#34;Buffer is modified, file position might not have been correct&#34;)))))
<a id="L867"></a><span class="ln">   867</span>	
<a id="L868"></a><span class="ln">   868</span>	(defun godef--call (point)
<a id="L869"></a><span class="ln">   869</span>	  &#34;Call godef, acquiring definition position and expression
<a id="L870"></a><span class="ln">   870</span>	description at POINT.&#34;
<a id="L871"></a><span class="ln">   871</span>	  (if (go--xemacs-p)
<a id="L872"></a><span class="ln">   872</span>	      (message &#34;godef does not reliably work in XEmacs, expect bad results&#34;))
<a id="L873"></a><span class="ln">   873</span>	  (if (not buffer-file-name)
<a id="L874"></a><span class="ln">   874</span>	      (message &#34;Cannot use godef on a buffer without a file name&#34;)
<a id="L875"></a><span class="ln">   875</span>	    (let ((outbuf (get-buffer-create &#34;*godef*&#34;)))
<a id="L876"></a><span class="ln">   876</span>	      (with-current-buffer outbuf
<a id="L877"></a><span class="ln">   877</span>	        (erase-buffer))
<a id="L878"></a><span class="ln">   878</span>	      (call-process-region (point-min) (point-max) &#34;godef&#34; nil outbuf nil &#34;-i&#34; &#34;-t&#34; &#34;-f&#34; (file-truename buffer-file-name) &#34;-o&#34; (number-to-string (go--position-bytes (point))))
<a id="L879"></a><span class="ln">   879</span>	      (with-current-buffer outbuf
<a id="L880"></a><span class="ln">   880</span>	        (split-string (buffer-substring-no-properties (point-min) (point-max)) &#34;\n&#34;)))))
<a id="L881"></a><span class="ln">   881</span>	
<a id="L882"></a><span class="ln">   882</span>	(defun godef-describe (point)
<a id="L883"></a><span class="ln">   883</span>	  &#34;Describe the expression at POINT.&#34;
<a id="L884"></a><span class="ln">   884</span>	  (interactive &#34;d&#34;)
<a id="L885"></a><span class="ln">   885</span>	  (condition-case nil
<a id="L886"></a><span class="ln">   886</span>	      (let ((description (nth 1 (godef--call point))))
<a id="L887"></a><span class="ln">   887</span>	        (if (string= &#34;&#34; description)
<a id="L888"></a><span class="ln">   888</span>	            (message &#34;No description found for expression at point&#34;)
<a id="L889"></a><span class="ln">   889</span>	          (message &#34;%s&#34; description)))
<a id="L890"></a><span class="ln">   890</span>	    (file-error (message &#34;Could not run godef binary&#34;))))
<a id="L891"></a><span class="ln">   891</span>	
<a id="L892"></a><span class="ln">   892</span>	(defun godef-jump (point)
<a id="L893"></a><span class="ln">   893</span>	  &#34;Jump to the definition of the expression at POINT.&#34;
<a id="L894"></a><span class="ln">   894</span>	  (interactive &#34;d&#34;)
<a id="L895"></a><span class="ln">   895</span>	  (condition-case nil
<a id="L896"></a><span class="ln">   896</span>	      (let ((file (car (godef--call point))))
<a id="L897"></a><span class="ln">   897</span>	        (cond
<a id="L898"></a><span class="ln">   898</span>	         ((string= &#34;-&#34; file)
<a id="L899"></a><span class="ln">   899</span>	          (message &#34;godef: expression is not defined anywhere&#34;))
<a id="L900"></a><span class="ln">   900</span>	         ((string= &#34;godef: no identifier found&#34; file)
<a id="L901"></a><span class="ln">   901</span>	          (message &#34;%s&#34; file))
<a id="L902"></a><span class="ln">   902</span>	         ((go--string-prefix-p &#34;godef: no declaration found for &#34; file)
<a id="L903"></a><span class="ln">   903</span>	          (message &#34;%s&#34; file))
<a id="L904"></a><span class="ln">   904</span>	         (t
<a id="L905"></a><span class="ln">   905</span>	          (push-mark)
<a id="L906"></a><span class="ln">   906</span>	          (godef--find-file-line-column file))))
<a id="L907"></a><span class="ln">   907</span>	    (file-error (message &#34;Could not run godef binary&#34;))))
<a id="L908"></a><span class="ln">   908</span>	
<a id="L909"></a><span class="ln">   909</span>	(provide &#39;go-mode)
</pre><p><a href="/misc/emacs/go-mode.el?m=text">View as plain text</a></p>

<div id="footer">
Build version go1.1.<br>
Except as <a href="http://code.google.com/policies.html#restrictions">noted</a>,
the content of this page is licensed under the
Creative Commons Attribution 3.0 License,
and code is licensed under a <a href="/LICENSE">BSD license</a>.<br>
<a href="/doc/tos.html">Terms of Service</a> | 
<a href="http://www.google.com/intl/en/policies/privacy/">Privacy Policy</a>
</div>

</div><!-- .container -->
</div><!-- #page -->

<script type="text/javascript">
(function() {
  var ga = document.createElement("script"); ga.type = "text/javascript"; ga.async = true;
  ga.src = ("https:" == document.location.protocol ? "https://ssl" : "http://www") + ".google-analytics.com/ga.js";
  var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ga, s);
})();
</script>
</body>
<script type="text/javascript">
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>
</html>

