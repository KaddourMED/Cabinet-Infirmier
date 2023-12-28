<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes">
    <xsl:output method="html"/>

    <!--Déclaration des variables et des paramètres dont nous avons besoin.-->

    <xsl:param name="destinedId" select="001"/>
    
    <xsl:variable name="visiteDuJour" select="count(//cab:patient/cab:visite[@intervenant=$destinedId])"/>
    
    <xsl:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>




    <!--Template Principale : Créez un document HTML en ajoutant le bloc <head> et <body> comme suit. 
    Le titre doit être "Profil de", suivi du nom de l'infirmier comme titre principal. Ensuite, 
    nous allons appeler un modèle pour l'infirmier qui affichera le message requis. Enfin, 
    nous afficherons la liste des patients que cet infirmier possède, et nous appellerons 
    un modèle pour afficher les informations sur chaque patient.-->
    
    <xsl:template match="/">
        <html>
            <head>
                <title>Profil de <xsl:value-of select='//cab:infirmier[@id=$destinedId]/cab:nom'/></title>
                <link rel="stylesheet" type="text/css" href="../css/infirmierPage.css" />
                <script type="text/javascript">
                    function openFacture(prenom, nom, actes) {
                        var width  = 500;
                        var height = 300;
                        if(window.innerWidth) {
                        var left = (window.innerWidth-width)/2;
                        var top = (window.innerHeight-height)/2;
                        }
                        else {
                        var left = (document.body.clientWidth-width)/2;
                        var top = (document.body.clientHeight-height)/2;
                        }
                        var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                        factureText = "Facture pour : " + prenom + " " + nom + " " + actes;
                        factureWindow.document.write(factureText);
                    }
                </script>
            </head>
            <body>
                <xsl:apply-templates select="//cab:infirmier[@id=$destinedId]"/>
                <h3>Liste des patients :</h3>
                <xsl:apply-templates select="//cab:patient[cab:visite[@intervenant=$destinedId]]" />
            </body>
        </html>
    </xsl:template>
    

    <!--Template qui affiche le message demandé : "Bonjour" suivi du nom de l'infirmier. 
    Ensuite, affichez "Aujourd'hui, vous avez" suivi du nombre de patients que vous avez aujourd'hui-->

    
    <xsl:template match="cab:infirmier">
        Bonjour <xsl:value-of select='//cab:infirmier[@id=$destinedId]/cab:nom'/>,<br/>
        <p>Aujourd'hui, vous avez <xsl:value-of select="$visiteDuJour"/> patients.<br/></p>
    </xsl:template>


    <!--Template patient : Affichez les coordonnées de chaque patient, telles que "nom", 
    "prénom" et "adresse". Ensuite, affichez "Acte de visite" pour montrer la visite du patient. 
    Ensuite, appelez un modèle de visite pour afficher la date de la visite et les actes associés.-->


    <xsl:template match="cab:patient">
        
        <br/>
        Nom : <xsl:value-of select="cab:nom"/> <br/>
        Prenom : <xsl:value-of select="cab:prénom"/>
        <br/>
        Adresse : <xsl:if test="cab:adresse/cab:étage != ''">
                    <xsl:value-of select="cab:adresse/cab:étage"/><sup>e</sup> étage,
                  </xsl:if>
         <xsl:value-of select="cab:adresse/cab:numéro"/>, <xsl:value-of select="cab:adresse/cab:rue"/>,  
         <xsl:value-of select="cab:adresse/cab:ville"/>, <xsl:value-of select="cab:adresse/cab:codePostal"/>  
        <br/>
        <h4>Acte de Visite :</h4>
        <xsl:apply-templates select="cab:visite"/> 
               
    </xsl:template>
    

    <!--Template visite : Affichez la date de la visite, puis affichez tous les actes. 
    Pour cela, faites appel à un autre modèle appelé "acte" pour afficher les différents actes possibles, 
    car une visite peut comporter deux actes ou plus.-->


    <xsl:template match="cab:visite">

        <p> Visite du <xsl:value-of select="@date" /></p>
        <xsl:apply-templates select="cab:acte"/>

    </xsl:template>
    

    <!--Template Acte : Affichez l'acte en utilisant l'ID correspondant à celui présent dans le fichier acte.xml. 
    Ensuite, affichez le bouton "Facture", car chaque acte est associé à une facture, et donc, nous le plaçons 
    dans cette template. Pour la facture, nous avons besoin du nom et du prénom du patient, 
    donc il est nécessaire de les rechercher en remontant dans la hiérarchie de notre XML.-->


    <xsl:template match="cab:acte">

        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="nom" select="../../cab:nom"/>
        <xsl:variable name="prénom" select="../../cab:prénom"/>

        <xsl:value-of select="$actes/act:actes/act:acte[@id = $id]"/>
        
        <br/>
        <br/>
        <button class="button" type="button">
            <xsl:attribute name="onclick">
                 openFacture(`<xsl:value-of select="$nom"/>`,
                 `<xsl:value-of select="$prénom"/>`,
                 `<xsl:value-of select="$actes/act:actes/act:acte[@id = $id]"/>`)
             </xsl:attribute>
             facture
        </button>
        <br/>
        <br/>
        <br/>

    </xsl:template>
    

</xsl:stylesheet>
