#!/usr/bin/env python
import os,re,glob,time

downloaddir = '/home/lei.qing/diveintogreasemonkey-2005-05-09/download/'
version = re.compile('fileversion "(.*?)">').search(file(downloaddir + '../xml/version.xml').read()).group(1)

print 'Content-type: text/html; charset=utf-8'
print
print '''<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Downloads [Dive Into Greasemonkey]</title>
<link rel="shortcut icon" href="/favicon.ico">
<link rel="stylesheet" href="../css/dig.css" type="text/css">
<meta http-equiv="Link" content='&lt;../css/modern.css&gt;; type="text/css"; rel=stylesheet, &lt;../css/empty.css&gt;; type="text/css"; rel=stylesheet'>
<link rev="made" href="mailto:mark@diveintomark.org">
<meta name="keywords" content="Firefox, Greasemonkey, Javascript, user script, userscript">
</head>

<body id="diveintogreasemonkey-org">
<div class="z" id="intro">
<div class="sectionInner">
<div class="sectionInner2">

<div class="s" id="pageHeader">
<h1><a href="../">Dive Into Greasemonkey</a></h1>
<p>Teaching an old web new tricks</p>
</div>

<div class="s">
<ul>
<li><a href="../">Home</a> &middot; </li>
<li><a href="../toc/">Table of contents</a> &middot; </li>
<li>Download &middot; </li>
<li><a href="http://greasemonkey.mozdev.org/">Get Greasemonkey</a></li>
</ul>
</div>

</div></div></div>

<div id="main"><div id="mainInner">
<p id="breadcrumb">You are here: <a href="../">Home</a> &#8594; <span class="thispage">Downloads</span></p>

<div class="section">
  <h2 class="skip">Downloads</h2>
  <div class="indexdownload">
    <h3>Book</h3>
    <p><cite>Dive Into Greasemonkey</cite> is a free download, available in a variety of formats.  The current version was published on''',
print time.strftime('%B %d, %Y.', time.strptime(version, '%Y-%m-%d')).replace(' 0', ' '),
print '''</p>
    <ul>
      <li><a title="Download as HTML" href="book/diveintogreasemonkey-html-''' + version + '''.zip">HTML</a></li>
      <li><a title="Download as HTML, plus supplementary video demonstrations" href="book/diveintogreasemonkey-html-plus-''' + version + '''.zip">HTML + videos</a></li>
      <li><a title="Download as HTML, all in one page" href="book/diveintogreasemonkey-html-flat-''' + version + '''.zip">HTML (single page)</a></li>
      <li><a title="Download as PDF" href="book/diveintogreasemonkey-pdf-''' + version + '''.zip">PDF</a></li>
      <li><a title="Download as text" href="book/diveintogreasemonkey-text-''' + version + '''.zip">Plain text</a></li>
      <li><a title="Download as Palm OS(tm) database" href="book/diveintogreasemonkey-pdb-''' + version + '''.zip">Palm OS&trade; database</a> (read it with <a title="Plucker home page" href="http://www.plkr.org/">Plucker</a>)</li>
      <li><a title="Download supplementary video demonstrations" href="book/diveintogreasemonkey-videos-''' + version + '''.zip">Videos</a></li>
      <li><a title="Download the book's XML source code and build scripts" href="book/diveintogreasemonkey-xml-''' + version + '''.zip">Source code + videos</a></li>
    </ul>
  </div>

  <div class="indexdownload">
    <h3>Example scripts</h3>
    <dl>
'''

namere = re.compile('@name\s+(.*?)\n')
descre = re.compile('@description\s+(.*?)\n')
versionre = re.compile('version (.*?) BETA!')
datere = re.compile('// 200(.*?)\n')
files = []
for f in glob.glob(downloaddir + '*.user.js'):
    data = file(f).read()
    files.append((namere.search(data).group(1).strip(),
                  descre.search(data).group(1).strip(),
                  versionre.search(data).group(1).strip(),
                  time.strftime('%B %d, %Y', time.strptime('200' + datere.search(data).group(1).strip(), '%Y-%m-%d')).replace(' 0', ' '),
                  os.path.basename(f)))
files.sort()
for scriptname, scriptdesc, scriptversion, scriptdate, scriptfile in files:
    print '<dt><a href="' + scriptfile + '">' + scriptname + '</a>'# + ' (' + scriptdate + ')'
    print '<dd>' + scriptdesc
    print '<br>'
    print '<span class="lastmodified">Last modified on ' + scriptdate + '</span>'

print '''
    </dl>
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
