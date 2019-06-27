<?xml version="1.0" encoding="UTF-8"?>
  <xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:sm="http://www.omg.org/techprocess/ab/SpecificationMetadata/" 
    xmlns:xsd ="http://www.w3.org/2001/XMLSchema#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fibo-fnd-utl-av="https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/"
    extension-element-prefixes="rdf rdfs owl skos dct sm fibo-fnd-utl-av "
    >
    
    <!-- This file is copyright 2018, Adaptive Inc.  -->
    <!-- All rights reserved. -->
    <!-- A limited license is provided to use and modify this file purely for the purpose of publishing FIBO to publicly accessible sites -->
    <!-- IT MAY NOT, IN WHOLE OR PART, BE USED, COPIED, DISTRIBUTED, MODIFIED OR USED AS THE BASIS OF ANY DERIVED WORK OR 
     FOR ANY OTHER PURPOSE -->
    <!-- To license for any other purpose, please contact info@adaptive.com -->
    
    
    <!-- This formats a clean modules RDF/XML file for display using Basic Expandble Tree List
       That is covered here https://codepen.io/marcomtr/pen/eJOepz -->
    <!-- It will show modules and ontologies with a tooltip for the abstract, and for the latter link to the widoco page-->
    
    <xsl:param name="GIT_BRANCH" select="'master'"/> <!-- Used for generating the WIDOCO link -->
    <xsl:param name="GIT_TAG_NAME" select="'latest'"/> <!-- Ditto -->
    
    <xsl:output method="html" indent="yes" media-type="text/html"/>
    <xsl:strip-space elements="*"/>

    <xsl:key name="children" match="*[@rdf:about]" use="@rdf:about"/>
    
    <xsl:template match="/">
      <html lang="en" >
        <head>
          <meta charset="UTF-8"/>
            <title>FIBOpedia</title>
          <xsl:call-template name="license"/>
         
<link type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
    rel="stylesheet" />
  <!--<link type="text/css" href="static/css/bootstrap.min.css" rel="stylesheet" />-->
  <link type="text/css" href="https://spec.edmcouncil.org/fibo/css/style.css" rel="stylesheet" />
 <xsl:call-template name="stylesheet"/>
  <link href="https://fonts.googleapis.com/css?family=Roboto:200,300,400,500,700" rel="stylesheet"/>
  <!-- Global site tag (gtag.js) - Google Analytics -->
<script async="true" src="https://www.googletagmanager.com/gtag/js?id=UA-124531442-2"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-124531442-2');
</script>
        </head>
<body>
  <header>
    <div class="container">
  
      <nav class="navbar navbar-expand-lg navbar-light">
        <a class="navbar-brand" href="https://edmcouncil.org" target="_blank"><img id="logo-fibo" src= "https://spec.edmcouncil.org/fibo/images/logo.png"/></a>
       <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">MENU
          <span class="navbar-toggler-icon"></span>
        </button>
        <ul class="navbar-links">
          <li>
            <a href="https://edmcouncil.org/events/event_list.asp" target="_blank">CALENDAR</a>
          </li>
          <li>
            <a href="https://edmcouncil.org/Login.aspx" target="_blank">GO TO EDMCONNECT</a>
          </li>
          <li>
            <a href="https://edmcouncil.org/login.aspx" target="_blank">SIGN IN</a>
          </li>
          <li>
            <a href="https://edmcouncil.org/page/NewWebReg" target="_blank">REGISTER</a>
          </li>
            <li class="ico">
          <a href="https://twitter.com/edmcouncil" target="_blank" class="foot-li"><i class="fab fa-twitter"></i></a>
        </li>
        <li class="ico">
          <a href="https://www.linkedin.com/company/edm-council/" target="_blank" class="foot-li"><i class="fab fa-linkedin-in"></i></a>
        </li>
        <li class="ico">
          <a href="https://www.youtube.com/edmcouncil" target="_blank" class="foot-li"><i class="fab fa-youtube"></i></a>
        </li>
         </ul> 
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                About FIBO
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/index.html">What is FIBO?</a>
                <a class="dropdown-item" href="https://edmcouncil.org/page/aboutfiboreview" target="_blank">EDMC FIBO</a>
              </div>
            </li>         
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                Development
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/development.html">FIBO Development Process</a>
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/working-group.html">FIBO Working Groups</a>
              </div>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                aria-haspopup="true" aria-expanded="false">
                Documentation
              </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/ontology_tools.html">Dedicated ontology tools</a>                 
                <!-- 
                <a class="dropdown-item"
                  href="fibopedia/master/2019Q1/FIBOpedia.html">Fibopedia</a> 
                <a class="dropdown-item" href="UMLCMP/index.html">FIBO as a concept model</a>    
                -->              
                <a class="dropdown-item"
                  href="https://spec.edmcouncil.org/fibo/production_SMIF_UML_diagrams_new_links.html">SMIF/UML Diagrams for FIBO</a> 
                  <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/ldf.html">linked data fragments</a>

              </div>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
              aria-haspopup="true" aria-expanded="false">
              Downloads
            </a>
              <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/products.html">All FIBO products</a>                
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/fibo_owl.html">fibo OWL</a>
                        
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/glossary_index.html">fibo glossary</a>
                <!-- 
                <a class="dropdown-item" href="datadictionary/master/2019Q1/">FIBO data
                  dictionary (excel/csv)</a> 
                -->
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/vocabulary.html">FIBO vocabulary (SKOS)</a>
                <a class="dropdown-item" href="https://spec.edmcouncil.org/fibo/fibo_schema_org.html">FIBO exension to schema.org</a> 
                </div>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://spec.edmcouncil.org/fibo/contact.html">Contact</a>
            </li>
          </ul>
        </div>
      </nav>
    
    </div>
  </header>
  <div class="container-fluid slider">
    <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
      <ol class="carousel-indicators">
        <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
        <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
      </ol>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img class="d-block w-100" src="https://spec.edmcouncil.org/fibo/images/baner2.png" alt="First slide"/>
          <div class="carousel-caption d-none d-md-block">
            <h2>Build-Test-Deploy-Maintain Methodology</h2>
            <p>FIBO is treated in the same way as program codes with the same challenges</p>
          </div>
        </div>
        <div class="carousel-item">
          <img class="d-block w-100" src="https://spec.edmcouncil.org/fibo/images/baner2.png" alt="Second slide"/>
          <div class="carousel-caption d-none d-md-block">
            <h2>Build, Test, Deploy, Maintain Methodology</h2>
            <p>Build is the process of fleshing out FIBO as RDF/OWL model using W3C Standards</p>
          </div>
        </div>
        <div class="carousel-item">
          <img class="d-block w-100" src="https://spec.edmcouncil.org/fibo/images/baner2.png" alt="Third slide"/>
          <div class="carousel-caption d-none d-md-block">
            <h2>Build, Test, Deploy, Maintain Methodology</h2>
            <p>Test includes unit tests, integration tests, "hygiene tests" and instance data tests</p>
          </div>
        </div>
      </div>
      <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
      </a>
      <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
      </a>
      <div class="fill-image-fibo"></div>
    </div>
  </div>
  <div class="container">
    <main>
      <article>
          <h1>FIBOpedia</h1>
          <p>This page allows you to navigate the tree structure of FIBO's Domains and Modules and drill down into the individual ontologies.<br/>
            If you hover the mouse over any item you’ll see its description.<br/> 
            For ontologies (the bottom level) it will tell you the status (either Production or Development) and clicking on one will take you to the web document for that ontology.
            These documents are automatically generated for each ontology using <a href="https://github.com/dgarijo/Widoco">WIzard for DOCumenting Ontologies (WIDOCO)</a> software, 
            which includes a graphical visualization of the ontology and related elements in a force-directed graph layout using <a href="http://vowl.visualdataweb.org/v2/">Visual Notation for OWL Ontologies (VOWL)</a>. 
          </p>
          <p>Note: it has not been possible to generate WIDOCO documents for all the Development ontologies in FIBO (there are currently about 100 missing). 
            Clicking on those ontologies will give you an error page. The FIBO team is working to avoid creating a link in such cases.</p>
          <br/>
</article>
</main>
          <ul class="tree">
             <xsl:for-each select="/rdf:RDF/owl:NamedIndividual[rdf:type/@rdf:resource='http://www.omg.org/techprocess/ab/SpecificationMetadata/Specification']">
                <li class="tree__item">
                  <span>
                    <a>
                      <xsl:attribute name="href" select="'#'"/>
                      <xsl:value-of select="rdfs:label"/>
                    </a>
                  </span>
                </li>
              <xsl:apply-templates select="key('children', dct:hasPart/@rdf:resource)" mode="child"/>
            </xsl:for-each>
          </ul>


                  


  </div>
<br/>
<br/>
  <footer>
    <div class="container">
      <div class="row">
        <div class="footer-sitemap col-md-4">
          <span class="footer-header">Sitemap</span>
          <div class="row">

            <div class="col-md-6">
              <ul>
                <li><a href="index.html">About</a></li>
                <li><a href="development.html">Development</a></li>
                <li><a href="working-group.html">FIBO Working Groups</a></li>
                <li><a href="ontology_tools.html">Ontology Tools</a></li>
                <li><a href="production_SMIF_UML_diagrams_new_links.html">SMIF / UML Diagrams</a></li>
                <li><a href="ldf.html">FIBO Linked Data Fragments</a></li>

              </ul>
            </div>
            <div class="col-md-6">
              <ul>
                <li><a href="products.html">All Products</a></li>
                <li><a href="fibo_owl.html">FIBO OWL</a></li>
                <li><a href="glossary_index.html">FIBO Glossary</a></li>
                <li><a href="vocabulary.html">FIBO Vocabulary</a></li>
                <li><a href="fibo_schema_org.html">FIBO Extension To Schema.org</a></li>
              </ul>
            </div>

            <!-- end content -->
          </div>
          <!-- end row -->
        </div>
        <!-- end footer-sitemap -->
        <div class="footer-contact col-md-3">
          <span class="footer-header">Contact Us</span>
          <ul>
            <li class="mail"><a href="mailto:info@edmcouncil.org">info@edmcouncil.org</a></li>
            <li class="phone">USA +1 <span style="color: #ffffff;">(646) 722-4381</span></li>
            <li class="phone">UK +44 (0) 1794 390044</li>
          </ul>
        </div>
        <!-- end footer-contact -->
      </div>
      <hr/>
      <div class="row">
        <div class="col-md-8">
  
      <p>
        © 2019 EDM Council. All rights reserved. DCAM and FIBO are registered trademarks of EDM Council.
        All other marks are the property of their respective owners. Membership Management Software Powered by
        YourMembership
      </p>
   
    <div class="footer-links">
      <ul>
<li><a href="https://cdn.ymaws.com/edmcouncil.org/resource/resmgr/Featured_Documents/Legal/EDMC__Terms_of_Use_032318.pdf" target="_blank">Terms of Use</a></li>
        <li><a href="https://cdn.ymaws.com/edmcouncil.org/resource/resmgr/Featured_Documents/Legal/EDMC_Privacy_Policy_032318.pdf" target="_blank">Privacy Policy</a></li>
        <li><a href="https://cdn.ymaws.com/edmcouncil.org/resource/resmgr/Featured_Documents/Legal/EDMC_Copyright_Policy_032318.pdf" target="_blank">Copyright</a></li>
      </ul>
    </div>
    </div>
    <div class="col-md-4">
        <div class="footer-social-links">
            <ul>
                <li class="twitter"><a href="https://twitter.com/edmcouncil" target="_blank">   </a> </li>
                <li class="linkedin"><a href="https://www.linkedin.com/company/edm-council/" target="_blank">   </a> </li>
            </ul>
            </div>
    </div>
    </div>
  </div>
  </footer>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" type="text/javascript" async="true" defer="true"></script>

<xsl:call-template name="script"/>  

      </body>
      </html>
    </xsl:template>
    
    <xsl:template match="*" mode="child">
      <li>
        <span>
          <xsl:variable name="style">
            <xsl:choose>
              <xsl:when test="contains(name(), 'Ontology')">tree__item</xsl:when>
              <xsl:when test="dct:hasPart">icon hasChildren</xsl:when>
              <xsl:otherwise>tree__item</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <div class="{$style}"></div>
          <a>
            <xsl:attribute name="href" >
               <xsl:choose>
                 <xsl:when test="contains(name(), 'Ontology')">
                   <xsl:value-of select="concat(substring-before(@rdf:about, '/ontology/'),
                     '/widoco/', $GIT_BRANCH, '/', $GIT_TAG_NAME, '/', substring-after(@rdf:about, '/ontology/'), 'index-en.html')"/>                
                 </xsl:when>
                 <xsl:otherwise>#</xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="title" select="dct:abstract"/>
            <xsl:variable name="maturity">
              <xsl:choose>
                <xsl:when test="contains(name(), 'Ontology')">
                  <xsl:variable name="rawMaturity" select="substring-after(fibo-fnd-utl-av:hasMaturityLevel/@rdf:resource, 'https://spec.edmcouncil.org/fibo/ontology/FND/Utilities/AnnotationVocabulary/')"/>
                  <xsl:choose>
                    <xsl:when test="$rawMaturity='Release'"> (Production)</xsl:when>
                    <xsl:when test="$rawMaturity='Provisional'"> (Development)</xsl:when>
                    <xsl:when test="$rawMaturity='Informative'"> (Development)</xsl:when>
                    <xsl:otherwise>()</xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
              </xsl:choose>
            </xsl:variable> 
            <xsl:value-of select="concat(rdfs:label, $maturity )"/>
          </a>
        </span>
        <xsl:if test="dct:hasPart">
          <ul>
            <xsl:apply-templates select="key('children', dct:hasPart/@rdf:resource)" mode="child"/>
          </ul>
        </xsl:if>
      </li>      
    </xsl:template>
    
     
    <xsl:template match="*" priority="-2"/>
    
    <xsl:template name="license">
      <xsl:comment>

This page makes use of Javascript and CSS which subject to the following license: 

Copyright (c) 2018 by Marco Monteiro (https://codepen.io/marcomtr/pen/eJOepz)


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

      </xsl:comment>
    </xsl:template>
    
    <xsl:template name="stylesheet">
      <style>
      body {
      font-family: Helvetica, sans-serif;
      font-size:15px;
      }
      
      a {
      text-decoration:none;
      }
      ul.tree, .tree li {
      list-style: none;
      margin:0;
      padding:0;
      cursor: pointer;
      }

      ul.tree:before, .tree li:before{
          border:0 !important;
      }
      .tree ul{
      display: none;
       }
      .tree > li {
      display:block;
      background:#eee;
      margin-bottom:2px;
      }
      
      .tree span {
      display:block;
      padding:10px 12px;
      
      }
      
      .icon {
      display:inline-block;
      }
      
      .tree .hasChildren > .expanded {
      background:#999;
      }
      
      .tree .hasChildren > .expanded a {
      color:#fff;
      }
      
      .icon:before {
      content:"+";
      display:inline-block;
      min-width:20px;
      text-align:center;
      }
      .tree .icon.expanded:before {
      content:"-";
      }
      
      .show-effect {
      display:block!important;
      }
      </style>
    </xsl:template>
    
    <xsl:template name="script">
      <script>
      $('.tree .icon').click( function() {
      $(this).parent().toggleClass('expanded').
      closest('li').find('ul:first').
      toggleClass('show-effect');
      });
      </script>
    </xsl:template>
            
</xsl:stylesheet>
