<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:template match="street|pob|postcode|city|state|
                       country|phone|fax|otheraddr">
    <xsl:call-template name="inline"/>
  </xsl:template>

</xsl:stylesheet>
