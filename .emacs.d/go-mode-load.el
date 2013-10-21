<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

  <title>misc/emacs/go-mode-load.el - The Go Programming Language</title>

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
  <h1>Text file misc/emacs/go-mode-load.el</h1>




<div id="nav"></div>


<pre><a id="L1"></a><span class="ln">     1</span>	;;; go-mode-load.el --- automatically extracted autoloads
<a id="L2"></a><span class="ln">     2</span>	;;; Commentary:
<a id="L3"></a><span class="ln">     3</span>	
<a id="L4"></a><span class="ln">     4</span>	;; To install go-mode, add the following lines to your .emacs file:
<a id="L5"></a><span class="ln">     5</span>	;;   (add-to-list &#39;load-path &#34;PATH CONTAINING go-mode-load.el&#34; t)
<a id="L6"></a><span class="ln">     6</span>	;;   (require &#39;go-mode-load)
<a id="L7"></a><span class="ln">     7</span>	;;
<a id="L8"></a><span class="ln">     8</span>	;; After this, go-mode will be used for files ending in &#39;.go&#39;.
<a id="L9"></a><span class="ln">     9</span>	;;
<a id="L10"></a><span class="ln">    10</span>	;; To compile go-mode from the command line, run the following
<a id="L11"></a><span class="ln">    11</span>	;;   emacs -batch -f batch-byte-compile go-mode.el
<a id="L12"></a><span class="ln">    12</span>	;;
<a id="L13"></a><span class="ln">    13</span>	;; See go-mode.el for documentation.
<a id="L14"></a><span class="ln">    14</span>	;;
<a id="L15"></a><span class="ln">    15</span>	;; To update this file, evaluate the following form
<a id="L16"></a><span class="ln">    16</span>	;;   (let ((generated-autoload-file buffer-file-name)) (update-file-autoloads &#34;go-mode.el&#34;))
<a id="L17"></a><span class="ln">    17</span>	
<a id="L18"></a><span class="ln">    18</span>	;;; Code:
<a id="L19"></a><span class="ln">    19</span>	
<a id="L20"></a><span class="ln">    20</span>	
<a id="L21"></a><span class="ln">    21</span>	;;;### (autoloads (go-download-play godoc gofmt-before-save go-mode)
<a id="L22"></a><span class="ln">    22</span>	;;;;;;  &#34;go-mode&#34; &#34;go-mode.el&#34; (20767 50749))
<a id="L23"></a><span class="ln">    23</span>	;;; Generated autoloads from go-mode.el
<a id="L24"></a><span class="ln">    24</span>	
<a id="L25"></a><span class="ln">    25</span>	(autoload &#39;go-mode &#34;go-mode&#34; &#34;\
<a id="L26"></a><span class="ln">    26</span>	Major mode for editing Go source text.
<a id="L27"></a><span class="ln">    27</span>	
<a id="L28"></a><span class="ln">    28</span>	This mode provides (not just) basic editing capabilities for
<a id="L29"></a><span class="ln">    29</span>	working with Go code. It offers almost complete syntax
<a id="L30"></a><span class="ln">    30</span>	highlighting, indentation that is almost identical to gofmt,
<a id="L31"></a><span class="ln">    31</span>	proper parsing of the buffer content to allow features such as
<a id="L32"></a><span class="ln">    32</span>	navigation by function, manipulation of comments or detection of
<a id="L33"></a><span class="ln">    33</span>	strings.
<a id="L34"></a><span class="ln">    34</span>	
<a id="L35"></a><span class="ln">    35</span>	Additionally to these core features, it offers various features to
<a id="L36"></a><span class="ln">    36</span>	help with writing Go code. You can directly run buffer content
<a id="L37"></a><span class="ln">    37</span>	through gofmt, read godoc documentation from within Emacs, modify
<a id="L38"></a><span class="ln">    38</span>	and clean up the list of package imports or interact with the
<a id="L39"></a><span class="ln">    39</span>	Playground (uploading and downloading pastes).
<a id="L40"></a><span class="ln">    40</span>	
<a id="L41"></a><span class="ln">    41</span>	The following extra functions are defined:
<a id="L42"></a><span class="ln">    42</span>	
<a id="L43"></a><span class="ln">    43</span>	- `gofmt&#39;
<a id="L44"></a><span class="ln">    44</span>	- `godoc&#39;
<a id="L45"></a><span class="ln">    45</span>	- `go-import-add&#39;
<a id="L46"></a><span class="ln">    46</span>	- `go-remove-unused-imports&#39;
<a id="L47"></a><span class="ln">    47</span>	- `go-goto-imports&#39;
<a id="L48"></a><span class="ln">    48</span>	- `go-play-buffer&#39; and `go-play-region&#39;
<a id="L49"></a><span class="ln">    49</span>	- `go-download-play&#39;
<a id="L50"></a><span class="ln">    50</span>	
<a id="L51"></a><span class="ln">    51</span>	If you want to automatically run `gofmt&#39; before saving a file,
<a id="L52"></a><span class="ln">    52</span>	add the following hook to your emacs configuration:
<a id="L53"></a><span class="ln">    53</span>	
<a id="L54"></a><span class="ln">    54</span>	\(add-hook &#39;before-save-hook &#39;gofmt-before-save)
<a id="L55"></a><span class="ln">    55</span>	
<a id="L56"></a><span class="ln">    56</span>	If you&#39;re looking for even more integration with Go, namely
<a id="L57"></a><span class="ln">    57</span>	on-the-fly syntax checking, auto-completion and snippets, it is
<a id="L58"></a><span class="ln">    58</span>	recommended to look at goflymake
<a id="L59"></a><span class="ln">    59</span>	\(https://github.com/dougm/goflymake), gocode
<a id="L60"></a><span class="ln">    60</span>	\(https://github.com/nsf/gocode) and yasnippet-go
<a id="L61"></a><span class="ln">    61</span>	\(https://github.com/dominikh/yasnippet-go)
<a id="L62"></a><span class="ln">    62</span>	
<a id="L63"></a><span class="ln">    63</span>	\(fn)&#34; t nil)
<a id="L64"></a><span class="ln">    64</span>	
<a id="L65"></a><span class="ln">    65</span>	(add-to-list &#39;auto-mode-alist (cons &#34;\\.go\\&#39;&#34; &#39;go-mode))
<a id="L66"></a><span class="ln">    66</span>	
<a id="L67"></a><span class="ln">    67</span>	(autoload &#39;gofmt-before-save &#34;go-mode&#34; &#34;\
<a id="L68"></a><span class="ln">    68</span>	Add this to .emacs to run gofmt on the current buffer when saving:
<a id="L69"></a><span class="ln">    69</span>	 (add-hook &#39;before-save-hook &#39;gofmt-before-save).
<a id="L70"></a><span class="ln">    70</span>	
<a id="L71"></a><span class="ln">    71</span>	Note that this will cause go-mode to get loaded the first time
<a id="L72"></a><span class="ln">    72</span>	you save any file, kind of defeating the point of autoloading.
<a id="L73"></a><span class="ln">    73</span>	
<a id="L74"></a><span class="ln">    74</span>	\(fn)&#34; t nil)
<a id="L75"></a><span class="ln">    75</span>	
<a id="L76"></a><span class="ln">    76</span>	(autoload &#39;godoc &#34;go-mode&#34; &#34;\
<a id="L77"></a><span class="ln">    77</span>	Show go documentation for a query, much like M-x man.
<a id="L78"></a><span class="ln">    78</span>	
<a id="L79"></a><span class="ln">    79</span>	\(fn QUERY)&#34; t nil)
<a id="L80"></a><span class="ln">    80</span>	
<a id="L81"></a><span class="ln">    81</span>	(autoload &#39;go-download-play &#34;go-mode&#34; &#34;\
<a id="L82"></a><span class="ln">    82</span>	Downloads a paste from the playground and inserts it in a Go
<a id="L83"></a><span class="ln">    83</span>	buffer. Tries to look for a URL at point.
<a id="L84"></a><span class="ln">    84</span>	
<a id="L85"></a><span class="ln">    85</span>	\(fn URL)&#34; t nil)
<a id="L86"></a><span class="ln">    86</span>	
<a id="L87"></a><span class="ln">    87</span>	;;;***
<a id="L88"></a><span class="ln">    88</span>	
<a id="L89"></a><span class="ln">    89</span>	(provide &#39;go-mode-load)
<a id="L90"></a><span class="ln">    90</span>	;; Local Variables:
<a id="L91"></a><span class="ln">    91</span>	;; version-control: never
<a id="L92"></a><span class="ln">    92</span>	;; no-byte-compile: t
<a id="L93"></a><span class="ln">    93</span>	;; no-update-autoloads: t
<a id="L94"></a><span class="ln">    94</span>	;; coding: utf-8
<a id="L95"></a><span class="ln">    95</span>	;; End:
<a id="L96"></a><span class="ln">    96</span>	;;; go-mode-load.el ends here
</pre><p><a href="/misc/emacs/go-mode-load.el?m=text">View as plain text</a></p>

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

