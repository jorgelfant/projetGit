<%--
  Created by IntelliJ IDEA.
  User: jorge.carrillo
  Date: 1/25/2020
  Time: 12:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                               La bibliothèque xml
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 Les flux ou fichiers XML sont très souvent utilisés dans les applications web, et la JSTL offrant ici un outil très
 simple d'utilisation pour effectuer quelques actions de base sur ce type de format, il serait bête de s'en priver.
 Toutefois, n'oubliez pas mon avertissement dans la conclusion du chapitre sur la bibliothèque Core : seuls certains
 cas particuliers justifient l'utilisation de la bibliothèque xml ; dans la plupart des applications MVC, ces actions
 ont leur place dans le modèle, et pas dans la vue !

Petite remarque avant de commencer : le fonctionnement de certaines balises étant très similaire à celui de balises
que nous avons déjà abordées dans le chapitre précédent sur la bibliothèque Core, ce chapitre sera par moments un peu
plus expéditif. :)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                             La syntaxe XPath
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Pour vous permettre de comprendre simplement les notations que j'utiliserai dans les exemples de ce chapitre, je dois
d'abord vous présenter le langage XML Path Language, ou XPath. Autant vous prévenir tout de suite, je ne vous présenterai
ici que succinctement les bases dont j'ai besoin. Un tuto à part entière serait nécessaire afin de faire le tour complet
des possibilités offertes par ce langage, et ce n'est pas notre objectif ici. Encore une fois, si vous êtes curieux,
les documentations et ressources ne manquent pas sur le web à ce sujet ! ;)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                             Le langage XPath
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Le langage XPath permet d'identifier les nœuds dans un document XML. Il fournit une syntaxe permettant de cibler
directement un fragment du document traité, comme un ensemble de nœuds ou encore un attribut d'un nœud en particulier,
de manière relativement simple. Comme son nom le suggère, path signifiant chemin en anglais, la syntaxe de ce langage
ressemble aux chemins d'accès aux fichiers dans un système : les éléments d'une expression XPath sont en effet séparés
par des slashs '/'.

Structure XML
------------
Voici la structure du fichier XML de test que j'utiliserai dans les quelques exemples illustrant ce paragraphe :

                                    <news>
                                      <article id="1">
                                        <auteur>Pierre</auteur>
                                        <titre>Foo...</titre>
                                        <contenu>...bar !</contenu>
                                      </article>
                                      <article id="27">
                                        <auteur>Paul</auteur>
                                        <titre>Bientôt un LdZ J2EE !</titre>
                                        <contenu>Woot ?</contenu>
                                      </article>
                                      <article id="102">
                                        <auteur>Jacques</auteur>
                                        <titre>Coyote court toujours</titre>
                                        <contenu>Bip bip !</contenu>
                                      </article>
                                    </news>

La syntaxe XPath

Plutôt que de paraphraser, voyons directement comment sélectionner diverses portions de ce document via des
expressions XPath, à travers des exemples commentés :

                <!-- Sélection du nœud racine -->
                /

                <!-- Sélection des nœuds 'article' enfants des nœuds 'news' -->
                /news/article

                <!-- Sélection de tous les nœuds inclus dans les nœuds 'article' enfants des nœuds 'news' -->
                /news/article/*

                <!-- Sélection de tous les nœuds 'auteur' qui ont deux parents quelconques -->
                /*/*/auteur

                <!-- Sélection de tous les nœuds 'auteur' du document via l'opérateur '//' -->
                //auteur

                <!-- Sélection de tous les nœuds 'article' ayant au moins un parent -->
                /*//article

                <!-- Sélection de l'attribut 'id' des nœuds 'article' enfants de 'news' -->
                /news/article/@id

                <!-- Sélection des nœuds 'article' enfants de 'news' dont la valeur du nœud 'auteur' est 'Paul' -->
                /news/article[auteur='Paul']

                <!-- Sélection des nœuds 'article' enfants de 'news' dont l'attribut id vaut '12' -->
                /news/article[@id='12']


Je m'arrêterai là pour les présentations. Sachez qu'il existe des commandes plus poussées que ces quelques éléments,
et je vous laisse le loisir de vous plonger dans les ressources que je vous ai communiquées pour plus d'information.
Mon objectif ici est simplement de vous donner un premier aperçu de ce qu'est la syntaxe XPath, afin que vous
compreniez sa logique et ne soyez pas perturbés lorsque vous me verrez utiliser cette syntaxe dans les attributs
de certaines balises de la bibliothèque xml.

J'imagine que cela reste assez flou dans votre esprit, et que vous vous demandez probablement comment diable ces
expressions vont pouvoir nous servir, et surtout où nous allons pouvoir les utiliser. Pas d'inquiétude : les
explications vous seront fournies au fur et à mesure que vous découvrirez les balises mettant en jeu ce type
d'expressions.

Pour ceux d'entre vous qui veulent tester les expressions XPath précédentes, ou qui veulent pratiquer en manipulant
d'autres fichiers XML et/ou en mettant en jeu d'autres expressions XPath, voici un site web qui vous permettra de
tester en direct le résultat de vos expressions sur le document XML de votre choix : XPath Expression Testbed.
Amusez-vous et vérifiez ainsi votre bonne compréhension du langage !

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                          Les actions de base
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Avant de vous présenter les différentes balises disponibles, je vous donne ici la directive JSP nécessaire pour permettre
l'utilisation des balises de la bibliothèque xml dans vos pages :

<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>

Retenez bien que cette directive devra être présente sur chacune des pages de votre projet utilisant les balises JSTL
que je vous présente dans ce chapitre. Dans un prochain chapitre concernant la création d'une bibliothèque personnalisée,
 nous verrons comment il est possible de ne plus avoir à se soucier de cette commande. En attendant, ne l'oubliez pas !

Récupérer et analyser un document
Je vais, dans ce paragraphe, vous montrer comment procéder pour récupérer et analyser simplement un fichier XML depuis
votre page JSP. Je reprends le fichier XML que j'ai utilisé précédemment lorsque je vous ai présenté la syntaxe du
langage XPath, et je le nomme monDocument.xml.

Commençons par aborder la récupération du fichier XML. Cette étape correspond simplement à un import, réalisé avec ce
tag de la bibliothèque Core que vous devez déjà connaître :

Remarquez l'utilisation de l'attribut varReader. C'est en quelque sorte un buffer, une variable qui sera utilisée pour
une utilisation postérieure du contenu du fichier importé. Notez que lorsque vous utiliserez cet attribut, il vous sera
impossible d'utiliser conjointement l'attribut var.

Rappelez-vous : lorsque l'on utilise cet attribut varReader, le contenu du fichier importé n'est pas inclus
littéralement dans votre page JSP comme c'est le cas lors d'un import simple ; il est copié dans la variable nommée
dans l'attribut varReader.

Le document XML étant récupéré et stocké dans la variable monReader, nous souhaitons maintenant l'analyser.
Nous allons, pour cela, faire intervenir une nouvelle balise, issue de la librairie xml cette fois :
--%>

<c:import url="monDocument.xml" varReader="monReader">
    <%-- Parse le contenu du fichier XML monDocument.xml dans une variable nommée 'doc' --%>
    <x:parse var="doc" doc="${monReader}" ></x:parse>
</c:import>

<%--
Deux attributs sont ici utilisés :

var : contient le nom de la variable de scope qui contiendra les données qui représentent notre document XML parsé.
Comme d'habitude, si l'attribut scope n'est pas explicité, la portée par défaut de cette variable sera la page ;

doc : permet de préciser que l'on souhaite parser le contenu de notre varReader défini précédemment lors de l'import.
Souvenez-vous : le varReader ici nommé monReader est une variable ; il nous faut donc utiliser une EL pour y faire
référence, en l'occurrence ${monReader} !

Dans certains codes vieillissants, vous trouverez parfois dans l'utilisation de la balise <x:parse> un attribut nommé xml.
Sachez qu'il joue le même rôle que l'attribut doc, et qu'il est déprécié : concrètement, il a été remplacé par doc, et
il ne faut donc plus l'utiliser.



--%>


</body>
</html>
