#!/usr/bin/env python
# -*- coding: utf8 -*-
import os,re,glob,time

downloaddir = os.path.dirname(os.path.abspath(__file__)) + "/"
version = re.compile('fileversion "(.*?)">').search(open(downloaddir + '../xml/version.xml').read()).group(1)

print('Content-type: text/html; charset=utf-8')
print()
print('''<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>下载 [深入浅出 Greasemonkey]</title>
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
<h1><a href="../">深入浅出 Greasemonkey</a></h1>
<p>教老网络学新把戏</p>
</div>

<div class="s">
<ul>
<li><a href="../">首页</a> &middot; </li>
<li><a href="../toc/">目录</a> &middot; </li>
<li>下载 &middot; </li>
<li><a href="http://greasemonkey.mozdev.org/">下载 Greasemonkey</a></li>
</ul>
</div>

</div></div></div>

<div id="main"><div id="mainInner">
<p id="breadcrumb">您的位置：<a href="../">首页</a> &#8594; <span class="thispage">下载</span></p>

<div class="section">
  <h2 class="skip">下载</h2>
  <div class="indexdownload">
    <h3>图书</h3>
    <p><cite>深入浅出 Greasemonkey</cite> 有多种格式可供免费下载。当前版本发布于 ''', end=' ')
print(time.strftime('%B %d, %Y.', time.strptime(version, '%Y-%m-%d')).replace(' 0', ' '), end=' ')
print('''</p>
    <ul>
      <li><a title="HTML 下载" href="book/diveintogreasemonkey-html-''' + version + '''.zip">HTML</a></li>
      <li><a title="HTML 和演示视频下载" href="book/diveintogreasemonkey-html-plus-''' + version + '''.zip">HTML + 视频</a></li>
      <li><a title="单页 HTML 下载" href="book/diveintogreasemonkey-html-flat-''' + version + '''.zip">HTML (单页)</a></li>
      <li><a title="PDF 下载" href="book/diveintogreasemonkey-pdf-''' + version + '''.zip">PDF</a></li>
      <li><a title="纯文本格式下载" href="book/diveintogreasemonkey-text-''' + version + '''.zip">纯文本</a></li>
      <li><a title="Palm OS(tm) 数据库下载" href="book/diveintogreasemonkey-pdb-''' + version + '''.zip">Palm OS&trade; 数据库</a> (使用 <a title="Plucker home page" href="http://www.plkr.org/">Plucker</a> 阅读)</li>
      <li><a title="演示视频下载" href="book/diveintogreasemonkey-videos-''' + version + '''.zip">Videos</a></li>
      <li><a title="XML 源代码和构建脚本下载" href="book/diveintogreasemonkey-xml-''' + version + '''.zip">源代码 + 视频</a></li>
    </ul>
  </div>

  <div class="indexdownload">
    <h3>实例脚本</h3>
    <dl>
''')

namere = re.compile('@name\s+(.*?)\n')
descre = re.compile('@description\s+(.*?)\n')
versionre = re.compile('version (.*?) BETA!')
datere = re.compile('// 200(.*?)\n')
files = []
for f in glob.glob(downloaddir + '*.user.js'):
    data = open(f).read()
    files.append((namere.search(data).group(1).strip(),
                  descre.search(data).group(1).strip(),
                  versionre.search(data).group(1).strip(),
                  time.strftime('%B %d, %Y', time.strptime('200' + datere.search(data).group(1).strip(), '%Y-%m-%d')).replace(' 0', ' '),
                  os.path.basename(f)))
files.sort()
for scriptname, scriptdesc, scriptversion, scriptdate, scriptfile in files:
    print('<dt><a href="' + scriptfile + '">' + scriptname + '</a>')# + ' (' + scriptdate + ')'
    print('<dd>' + scriptdesc)
    print('<br>')
    print('<span class="lastmodified">最新修改于 ' + scriptdate + '</span>')

print('''
    </dl>
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
