#!/usr/bin/env python
import os, re, time, stat

#basedir = os.path.join('/', 'home', 'f8dy', 'web', 'diveintogreasemonkey.org')
basedir = os.path.join('/', 'home', 'lei.qing', 'diveintogreasemonkey-2005-05-09')
xmldir = os.path.join(basedir, 'xml')
downloaddir = os.path.join(basedir, 'download', 'book')
version = re.compile('fileversion "(.*?)">').search(file(os.path.join(xmldir, 'version.xml')).read()).group(1)

print 'Content-type: text/html; charset=utf-8'
print
print '''<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Dive Into Greasemonkey</title>
<link rel="shortcut icon" href="/favicon.ico">
<link rel="stylesheet" href="css/dig.css" type="text/css">
<meta http-equiv="Link" content='&lt;css/modern.css&gt;; type="text/css"; rel=stylesheet, &lt;css/empty.css&gt;; type="text/css"; rel=stylesheet'>
<link rev="made" href="mailto:mark@diveintomark.org">
<meta name="keywords" content="Firefox, Greasemonkey, Javascript, user script, userscript">
</head>

<body id="diveintogreasemonkey-org">
<div class="z" id="intro">
<div class="sectionInner">
<div class="sectionInner2">
<div class="s">
<h1>Dive Into Greasemonkey</h1>
<p>Teaching an old web new tricks</p>
</div>

<div class="s">
<ul>
<li>Home &middot; </li>
<li><a href="toc/">Table of contents</a> &middot; </li>
<li><a href="download/">Download</a> &middot; </li>
<li><a href="http://greasemonkey.mozdev.org/">Get Greasemonkey</a></li>
</ul>
</div>

</div></div></div>

<div id="main"><div id="mainInner">
<p id="breadcrumb">&nbsp;</p>

<div class="section">
  <h2 class="skip">Introduction</h2>
  <div class="indexread">
    <h3><a class="indexlink" title="Dive Into Greasemonkey table of contents" href="toc/">Read now</a></h3>
    <p><cite>Dive Into Greasemonkey</cite> is a book about programming with <a title="Greasemonkey home page" href="http://greasemonkey.mozdev.org/">Greasemonkey</a>, a Firefox extension for customizing web pages.  <a title="Dive Into Greasemonkey table of contents" href="toc/">Read it online</a> for free.</p>
    <p>Confused already?  Start with <a href="install/what-is-greasemonkey.html">What is Greasemonkey?</a></p>
  </div>

  <div class="indexdownload">
    <h3><a class="indexlink" title="Dive Into Greasemonkey download page" href="http://diveintogreasemonkey.org/download/">Read later</a></h3>
    <p><cite>Dive Into Greasemonkey</cite> is a free download, available in a variety of formats.  The current version was published on''',
print time.strftime('%B %d, %Y.', time.strptime(version, '%Y-%m-%d')).replace(' 0', ' '),
print '''</p>
    <ul>'''
htmlfile = os.path.join('download', 'book', 'diveintogreasemonkey-html-' + version + '.zip')
pdffile = os.path.join('download', 'book', 'diveintogreasemonkey-pdf-' + version + '.zip')
try:
    htmlsize = ' (' + str(int(os.stat(os.path.join(basedir, htmlfile))[stat.ST_SIZE]) / 1024) + ' KB)'
    pdfsize = ' (' + str(int(os.stat(os.path.join(basedir, pdffile))[stat.ST_SIZE]) / 1024) + ' KB)'
except Exception, e:
    htmlsize = ''
    pdfsize = ''
print '''
      <li><a title="Download as HTML''' + htmlsize + '''" href="''' + htmlfile + '''">HTML</a></li>
      <li><a title="Download as PDF''' + pdfsize + '''" href="''' + pdffile + '''">PDF</a></li>
      <li><a href="download/">more downloads</a></li>
    </ul>
  </div>
</div>
<hr>

<div class="footer">
  <p class="copyright">Copyright &copy; 2005 Mark Pilgrim &middot; <a title="send me feedback about this book" href="mailto:mark@diveintomark.org">mark@diveintomark.org</a> &middot; <a href="license/gpl.html" title="GNU General Public License">Terms of use</a></p>
</div>

</div></div>
</body>
</html>
'''
