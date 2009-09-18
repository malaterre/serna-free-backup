<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:param name="resume.word">������</xsl:param>
  <xsl:param name="page.word">���</xsl:param>
<!-- Word to use for "Contact Information" -->  <xsl:param name="contact.word">��������</xsl:param>
  <xsl:param name="objective.word">�������� �������</xsl:param>
<!-- Word to use for "Employment History" -->  <xsl:param name="history.word">���������������� ����</xsl:param>
  <xsl:param name="academics.word">�����������</xsl:param>
  <xsl:param name="publications.word">����������</xsl:param>
  <xsl:param name="interests.word">��������</xsl:param>
  <xsl:param name="security-clearances.word">������� � �����������</xsl:param>
  <xsl:param name="awards.word">�������</xsl:param>
  <xsl:param name="miscellany.word">������</xsl:param>
<!-- Word to use for "in", as in "bachelor degree *in* political science" -->  <xsl:param name="in.word"/>
<!-- Word to use for "and", as in "Minors in political science, English, *and*
  business" -->  <xsl:param name="and.word">�</xsl:param>
<!-- Word to use for "Copyright (c)" -->  <xsl:param name="copyright.word">Copyright ��</xsl:param>
<!-- Word to use for "by", as in "Copyright by Joe Doom" -->  <xsl:param name="by.word"/>
<!-- Word to use for "present", as in "Period worked: August 1999-Present" -->  <xsl:param name="present.word">��������� �����</xsl:param>
  <xsl:param name="achievements.word">����������:</xsl:param>
  <xsl:param name="projects.word">�������:</xsl:param>
<!-- Word to use for "minor" (lesser area of study), singluar and plural. -->  <xsl:param name="minor.word">�������������</xsl:param>
  <xsl:param name="minors.word">���. �������������</xsl:param>
  <xsl:param name="referees.word">������������</xsl:param>
<!-- Word to use for "Overall GPA", as in "*Overall GPA*: 3.3" -->  <xsl:param name="overall-gpa.word">����� ������� ���</xsl:param>
<!-- Word to use for "GPA in Major", as in "*GPA in Major*: 3.3" -->  <xsl:param name="major-gpa.word">�������� ��� �� �������������</xsl:param>
<!-- Text to use for "out of", as in "GPA: 3.71* out of *4.00" -->  <xsl:param name="out-of.word"> �� </xsl:param>
<!-- Phrase to display when referees are hidden. -->  <xsl:param name="referees.hidden.phrase">�� �������</xsl:param>
  <xsl:param name="last-modified.phrase">��������� ����������:</xsl:param>
  <xsl:param name="phone.word">���.</xsl:param>
  <xsl:param name="fax.word">����</xsl:param>
  <xsl:param name="phone.home.phrase">�������� <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase">������� <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.mobile.phrase">��������� <xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="fax.home.phrase">�������� <xsl:value-of select="$fax.word"/></xsl:param>
  <xsl:param name="fax.work.phrase">������� <xsl:value-of select="$fax.word"/></xsl:param>
  <xsl:param name="pager.word">�������</xsl:param>
  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>
<!-- Instant messenger service names --><!-- (When you add or remove a service here, don't forget to update
  ../../lib/common.xsl and element.instantMessage.xml in the user guide.)
  -->  <xsl:param name="im.aim.service">AIM</xsl:param>
  <xsl:param name="im.icq.service">ICQ</xsl:param>
  <xsl:param name="im.irc.service">IRC</xsl:param>
  <xsl:param name="im.jabber.service">Jabber</xsl:param>
  <xsl:param name="im.msn.service">MSN Messenger</xsl:param>
  <xsl:param name="im.yahoo.service">Yahoo! Messenger</xsl:param>
</xsl:stylesheet>
