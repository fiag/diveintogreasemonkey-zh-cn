#!/usr/bin/env python
# -*- coding: utf8 -*- 
import os, re, time, stat

#basedir = os.path.join('/', 'home', 'f8dy', 'web', 'diveintogreasemonkey.org')
basedir = os.path.dirname(os.path.abspath(__file__))

xmldir = os.path.join(basedir, 'xml')
downloaddir = os.path.join(basedir, 'download', 'book')
version = re.compile('fileversion "(.*?)">').search(file(os.path.join(xmldir, 'version.xml')).read()).group(1)

print('Content-type: text/html; charset=utf-8')
print()
print('''<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>深入浅出 Greasemonkey</title>
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
<h1>深入浅出 Greasemonkey</h1>
<p>教老网络学新把戏</p>
</div>

<div class="s">
<ul>
<li>首页 &middot; </li>
<li><a href="toc/">目录</a> &middot; </li>
<li><a href="download/">下载</a> &middot; </li>
<li><a href="http://www.greasespot.net/">下载 Greasemonkey</a></li>
</ul>
</div>

</div></div></div>

<div id="main"><div id="mainInner">
<p id="breadcrumb">&nbsp;</p>

<div class="section">
  <h2 class="skip">介绍</h2>
  <div class="indexread">
    <h3><a class="indexlink" title="深入浅出 Greasemonkey 目录" href="toc/">阅读</a></h3>
    <p><cite>深入浅出 Greasemonkey</cite> 是一本介绍用 <a title="Greasemonkey 主页" href="http://greasemonkey.mozdev.org/">Greasemonkey</a> 编程的书。Greasemonkey 是用来定制网页的 Firefox 扩展。免费<a title="深入浅出 Greasemonkey table of contents" href="toc/">在线阅读</a>。</p>
    <p>有些疑惑？就从 "<a href="install/what-is-greasemonkey.html">什么是 Greasemonkey?</a>" 开始吧！</p>
  </div>

  <div class="indexdownload">
    <h3><a class="indexlink" title="深入浅出 Greasemonkey 下载页" href="http://diveintogreasemonkey.org/download/">稍后再读</a></h3>
    <p><cite>深入浅出 Greasemonkey</cite> 有多种格式可供免费下载。当前版本发布于 ''', end=' ')
print(time.strftime('%B %d, %Y.', time.strptime(version, '%Y-%m-%d')).replace(' 0', ' '), end=' ')
print('''</p>
    <ul>''')
htmlfile = os.path.join('download', 'book', 'diveintogreasemonkey-html-' + version + '.zip')
pdffile = os.path.join('download', 'book', 'diveintogreasemonkey-pdf-' + version + '.zip')
try:
    htmlsize = ' (' + str(int(os.stat(os.path.join(basedir, htmlfile))[stat.ST_SIZE]) / 1024) + ' KB)'
    pdfsize = ' (' + str(int(os.stat(os.path.join(basedir, pdffile))[stat.ST_SIZE]) / 1024) + ' KB)'
except Exception as e:
    htmlsize = ''
    pdfsize = ''
print('''
      <li><a title="下载 HTML 格式''' + htmlsize + '''" href="''' + htmlfile + '''">HTML</a></li>
      <li><a title="下载 PDF 格式''' + pdfsize + '''" href="''' + pdffile + '''">PDF</a></li>
      <li><a href="download/">更多下载</a></li>
    </ul>
  </div>
</div>
<hr>

<div class="footer">
  <p class="copyright">Copyright &copy; 2005 Mark Pilgrim &middot; <a title="send me feedback about this book" href="mailto:mark@diveintomark.org">mark@diveintomark.org</a> &middot; <a href="license/gpl.html" title="GNU 通用公共许可证">使用许可</a></p>
</div>

</div></div>
</body>
</html>
''')
