<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical">
    
    <xsl:output method="html"/>


    <!--Template Principale : Créez un document HTML en ajoutant les blocs <head> et <body> comme suit. 
    Le titre doit être "Patients", suivi de l'affichage des informations du patient dans un tableau 
    tel que demandé : nom, prénom, sexe, date de naissance, numéro de sécurité sociale, adresse, et 
    les visites qu'il a effectuées. Toutes ces informations doivent être présentées dans un tableau. 
    Pour les visites, nous utiliserons une autre template afin de garantir l'affichage de toutes les visites, 
    car un patient peut avoir plusieurs visites.-->


    <xsl:template match="/">
        <html>
            <head>
                <title>Patients</title>
                <link rel="stylesheet" type="text/css" href="../css/pagePatient.css" />
            </head>

            <body>
                 <table border="1">
                    <ul>
                        <li>Nom : <xsl:value-of select="cab:patient/cab:nom"/></li>
                        <li>Prénom : <xsl:value-of select="cab:patient/cab:prénom"/></li>
                        <li>Sexe : <xsl:value-of select="cab:patient/cab:sexe"/></li>
                        <li>Naissance : <xsl:value-of select="cab:patient/cab:naissance"/></li>
                        <li>N°securite sociale : <xsl:value-of select="cab:patient/cab:numéro"/></li>
                        <li>Adresse : <xsl:value-of select="cab:patient/cab:adresse/cab:rue"/>, 
                        <xsl:value-of select="cab:patient/cab:adresse/cab:codePostal"/> 
                        (<xsl:value-of select="cab:patient/cab:adresse/cab:ville"/>)</li>
                        <h2>Visite</h2>
                        <table border="1">
                            <tr>
                                <th>Date</th>
                                <th>Soins à éffectuer</th>
                                <th>Intervenant</th>
                            </tr>
                            <xsl:apply-templates select="//cab:visite"></xsl:apply-templates>
                        </table>
                    </ul>
                </table>
            </body>

        </html>
    </xsl:template>
    

    <!--Template Visite : Affichez les informations de la visite telles que la date de la visite
    et l'acte à effectuer. Ensuite, affichez le nom de l'intervenant. 
    Tout cela constitue une ligne dans le tableau des visites.-->


    <xsl:template match="cab:visite">
        <td><xsl:value-of select="@date"/></td>
        <td><xsl:value-of select="cab:acte"/></td>
        <td><xsl:value-of select="cab:intervenant/cab:nom"/></td>
    </xsl:template>

</xsl:stylesheet>
