<?xml version="1.0" encoding="UTF-8"?>


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act="http://www.ujf-grenoble.fr/l3miage/actes"
                xmlns:xs="http://www.w3.org/2001/XMLSchema-instance">
    <xsl:output method="xml"/>

    
    <xsl:param name="destinedName" select="'Alécole'"/> 
    

    <!--Template Principale : Créer un document XML à partir des fichiers XML acte.xml 
    et cabinet.xml. Nous débutons en ouvrant une balise "patient", comme requis. 
    Ensuite, à l'intérieur de la balise "patient", nous appelons 
    le patient recherché en utilisant un chemin XPath spécifié.-->

    
    <xsl:template match="/">

        <cab:patient>

            <!--On ajoute un attribut à la balise "patient" car 
            nous en aurons besoin ultérieurement pour obtenir 
            le chemin vers "patient.xsd". Ceci est nécessaire 
            pour tester si le XML généré respecte correctement le schéma XML.-->

            <xsl:attribute name="xs:schemaLocation">http://www.ujf-grenoble.fr/l3miage/medical ../xsd/patient.xsd</xsl:attribute>

            <!-- La template est utilisée sur le patient dont le nom correspond 
            à celui passé en paramètre, après quoi toutes ses informations 
            sont affichées dans ladite template.-->

            <xsl:apply-templates select="//cab:patient[cab:nom=$destinedName]"/>
        </cab:patient>
        
    </xsl:template>
    

    <!--Template Patient : Affiche les coordonnées du patient récupérées 
    à partir du fichier XML, notamment le nom, le prénom, le sexe, 
    la date de naissance, le numéro de sécurité sociale, l'adresse 
    complète avec la rue, le code postal et la ville. 
    Ensuite, on appelle une autre template "visite" pour afficher toutes 
    les visites possibles, car un patient peut avoir plusieurs visites.-->

    
    <xsl:template match="cab:patient">

        <cab:nom><xsl:value-of select="cab:nom"/></cab:nom>
        <cab:prénom><xsl:value-of select="cab:prénom"/></cab:prénom>
        <cab:sexe><xsl:value-of select="cab:sexe"/></cab:sexe>
        <cab:naissance><xsl:value-of select="cab:naissance"/></cab:naissance>
        <cab:numéro><xsl:value-of select="cab:numéro"/></cab:numéro>
        <cab:adresse>
            <cab:rue><xsl:value-of select="cab:adresse/cab:rue"/></cab:rue>
            <cab:codePostal><xsl:value-of select="cab:adresse/cab:codePostal"/></cab:codePostal>
            <cab:ville><xsl:value-of select="cab:adresse/cab:ville"/></cab:ville>
        </cab:adresse>
        <xsl:apply-templates select="cab:visite"/>

    </xsl:template>
    

    <!--Template Visite : Cette template permet d'afficher la balise "visite" 
    qui possède un attribut "date". Elle inclut également une autre balise 
    "intervenant" qui contient le nom et le prénom de l'intervenant chargé 
    de gérer la visite du patient.-->

    
    <xsl:template match="cab:visite">
        <cab:visite> 

            <xsl:attribute name="date"><xsl:value-of select="@date"/></xsl:attribute>

            <cab:intervenant>

                <!-- On stocke l'id de l'infirmiere dans une variable-->
                <xsl:variable name="destinedId" select="@intervenant"/> 

                <cab:nom><xsl:value-of select="//cab:infirmier[@id=$destinedId]/cab:nom"/></cab:nom>
                <cab:prénom><xsl:value-of select="//cab:infirmier[@id=$destinedId]/cab:prénom"/></cab:prénom>

            </cab:intervenant>

            <!-- Pour chaque acte on affiche sa descripiton-->
            <xsl:apply-templates select="cab:acte"/>

        </cab:visite>

    </xsl:template>
    
    
    <!--Template Acte : Affiche la description de chaque acte 
    récupérée à partir du document acte.xml. -->


    <xsl:template match="cab:acte">

        <!-- Pour chaque acte du patient -->
        <xsl:variable name="idActe" select="@id"/> 


        <!-- Pour chaque id du patient on regarde dans l'arborescence
        du fichiers actes.xml lorsque l'acte est égale à l'id du patient-->
        <xsl:variable name="actes" select="document('actes.xml', /)/act:ngap/act:actes/act:acte[@id=$idActe]"/>


        <!-- Puis on affiche la description pour chauqe acte-->
        <cab:acte><xsl:value-of select="$actes"/></cab:acte>

    </xsl:template>

</xsl:stylesheet>   