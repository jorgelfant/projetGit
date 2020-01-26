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
    <x:parse var="doc" doc="${monReader}"></x:parse>
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

Note : l'import qui stocke le fichier dans le varReader doit rester ouvert pour pouvoir appliquer un <x:parse> sur le
contenu de ce varReader ! La portée du varReader défini est en effet uniquement l'intérieur du corps du <c:import>.
Afin de pouvoir accéder à ce varReader, il ne faut donc pas fermer directement la balise d'import comme c'est le cas
ci-dessous :


                             -- Mauvaise utilisation du varReader --
                  <c:import url="monDocument.xml" varReader="monReader" ></c:import>

Toutefois, il est possible de ne pas utiliser le varReader, et de simplement utiliser une variable de scope.
Vous pourrez ainsi faire votre import, puis traiter le contenu du fichier par la suite, sans devoir travailler dans
le corps de la balise d'import :

                       <c:import url="monDocument.xml" var="monReader" ></code>

Cela dit, je vous conseille de travailler avec le varReader, puisque c'est l'objectif premier de cet attribut.

Plusieurs remarques sont d'ores et déjà nécessaires.
***************************************************

Comprenez bien ici la différence entre le varReader de la balise <c:import> et le var de la balise <x:parse>:
le premier contient le contenu brut du fichier XML, alors que le second contient le résultat du parsing du fichier XML.
Pour faire simple, la JSTL utilise une structure de données qui représente notre document XML parsé, et c'est cette
structure qui est stockée dans la variable définie par var.

Le type de la variable définie via cet attribut var dépendra de l'implémentation choisie par le développeur. Pour
information, il est possible de remplacer l'attribut var par l'attribut nommé varDom, qui permet de fixer l'implémentation
utilisée : la variable ainsi définie sera de type org.w3c.dom.Document. De même, scope sera remplacé par scopeDom.
Ceci impose donc que votre fichier XML respecte l'interface Document citée précédemment. Tout cela étant vraiment
spécifique, je ne m'étalerai pas davantage sur le sujet et je vous renvoie à la documentation pour plus d'infos.

Importer un fichier n'est pas nécessaire. Il est en effet possible de traiter directement un flux XML depuis la page JSP,
en le plaçant dans le corps de la balise <x:parse> :

-- Parse le flux XML contenu dans le corps de la balise --

--%>
<x:parse var="doc" >
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
</x:parse>

<%--
Il reste seulement deux attributs que je n'ai pas encore abordés :

filter : permet de limiter le contenu traité par l'action de parsing <x:parse> à une portion d'un flux XML seulement.
         Cet attribut peut s'avérer utile lors de l'analyse de documents XML lourds, afin de ne pas détériorer les performances
         à l'exécution de votre page. Pour plus d'information sur ces filtres de type XMLFilter, essayez la documentation.

systemId : cet attribut ne vous sera utile que si votre fichier XML contient des références vers des entités externes.
           Vous devez y saisir l'adresse URI qui permettra de résoudre les liens relatifs contenus dans votre fichier XML.
           Bref rappel : une référence à une entité externe dans un fichier XML est utilisée pour y inclure un fichier
           externe, principalement lorsque des données ou textes sont trop longs et qu'il est plus simple de les garder
           dans un fichier à part. Le processus accédera à ces fichiers externes lors du parsage du document XML spécifié.

Je n'ai, pour ces derniers, pas d'exemple trivial à vous proposer. Je fais donc volontairement l'impasse ici ; je pense
que ceux parmi vous qui connaissent et ont déjà manipulé les filtres XML et les entités externes comprendront aisément
de quoi il s'agit.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                               Afficher une expression
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Les noms des balises que nous allons maintenant aborder devraient vous être familiers : ils trouvent leurs équivalents
dans la bibliothèque Core que vous avez découverte dans le chapitre précédent. Alors que les balises de type Core
accédaient à des données de l'application en utilisant des EL, les balises de la bibliothèque xml vont accéder à des
données issues de documents XML, via des expressions XPath.

Pour afficher un élément, nous allons utiliser la balise <x:out>, pour laquelle seul l'attribut select est nécessaire :

--%>
<c:import url="monDocument.xml" varReader="monReader">
    <%-- Parse le contenu du fichier XML monDocument.xml dans une variable nommée 'doc' --%>
    <x:parse var="doc" doc="${monReader}" ></x:parse>
    <x:out select="$doc/news/article/auteur" ></x:out>
</c:import>

<%--
Le rendu HTML du code ci-dessus est alors le suivant :

Pierre


En suivant le paragraphe introduisant XPath, j'avais compris qu'une telle expression renvoyait tous les nœuds "auteur"
du document !
Où sont passés Paul et Jacques ? Où est l'erreur ?

Hé hé... Eh bien, à vrai dire il n'y a aucune erreur ! En effet, l'expression XPath renvoie bel et bien un ensemble
de nœuds, en l'occurrence les nœuds "auteur" ; cet ensemble de nœuds est stocké dans une structure de type NodeSet,
un type propre à XPath qui implémente le type Java standard NodeList.

Le comportement ici observé provient du fait que la balise d'affichage <x:out> ne gère pas réellement un ensemble de
nœuds, et n'affiche que le premier nœud contenu dans cet ensemble de type NodeSet. Toutefois, le contenu de l'attribut
select peut très bien contenir un NodeSet ou une opération sur un NodeSet. Vérifions par exemple que NodeSet contient
bien 3 nœuds, puisque nous avons 3 auteurs dans notre document XML :

--%>

<c:import url="monDocument.xml" varReader="monReader">
    <%-- Parse le contenu du fichier XML monDocument.xml dans une variable nommée 'doc' --%>
    <x:parse var="doc" doc="${monReader}" ></x:parse>
    <x:out select="count($doc/news/article/auteur)" ></x:out>
</c:import>

<%--
J'utilise ici la fonction count(), qui renvoie le nombre d'éléments que l'expression XPath a sélectionnés et stockés
dans le NodeSet. Et le rendu HTML de cet exemple est bien "3" ; notre ensemble de nœuds contient donc bien trois auteurs,
Paul et Jacques ne sont pas perdus en cours de route. :)

L'attribut select de la balise <x:out> est l'équivalent de l'attribut value de la balise <c:out>, sauf qu'il attend ici
une expression XPath et non plus une EL ! Rappelez-vous que le rôle des expressions XPath est de sélectionner des portions
de document XML. Expliquons rapidement l'expression <x:out select="$doc/news/article/auteur" /> : elle va sélectionner
tous les nœuds "auteur" qui sont enfants d'un nœud "article" lui-même enfant du nœud racine "news" présent dans le
document $doc. En l'occurrence, $doc se réfère ici au contenu parsé de notre variable varReader.

Dans une expression XPath, pour faire référence à une variable nommée nomVar on n'utilise pas ${nomVar} comme c'est le
cas dans une EL, mais $nomVar. Essayez de retenir cette syntaxe, cela vous évitera bien des erreurs ou des comportements
inattendus !

À ce sujet, sachez enfin qu'outre une variable simple, il est possible de faire intervenir les objets implicites dans
une expression XPath, de cette manière :
--%>

<%-- Récupère le document nommé 'doc' enregistré auparavant en session, via l'objet implicite sessionScope  --%>
<x:out select="$sessionScope:doc/news/article" ></x:out>

<%-- Sélectionne le nœud 'article' dont l'attribut 'id' a pour valeur le contenu de la variable
 nommée 'idArticle' qui a été passée en paramètre de la requête, via l'objet implicite param  --%>
<x:out select="$doc/news/article[@id=$param:idArticle]"></x:out>

<%--
Ce qu'on peut retenir de cette balise d'affichage, c'est qu'elle fournit, grâce à un fonctionnement basé sur des
expressions XPath, une alternative aux feuilles de style XSL pour la transformation de contenus XML, en particulier
lorsque le format d'affichage final est une page web HTML.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                Créer une variable
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Nous passerons très rapidement sur cette balise. Sa syntaxe est <x:set>, et comme vous vous en doutez elle est
l'équivalent de la balise <c:set> de la bibliothèque Core, avec de petites différences :

l'attribut select remplace l'attribut value, ce qui a la même conséquence que pour la balise d'affichage :
une expression XPath est attendue, et non pas une EL ;

l'attribut var est obligatoire, ce qui n'était pas le cas pour la balise <c:set>.

Ci-dessous un bref exemple de son utilisation :

--%>

<%-- Enregistre le résultat de l'expression XPath, spécifiée dans l'attribut select,
dans une variable de session nommée 'auteur' --%>
<x:set var="auteur" scope="session" select="$doc//auteur" ></x:set>

<%-- Affiche le contenu de la variable nommée 'auteur' enregistrée en session --%>
<x:out select="$sessionScope:auteur" ></x:out>

<%--
Le rôle de cette balise est donc sensiblement le même que son homologue de la bibliothèque Core : enregistrer
le résultat d'une expression dans une variable de scope. La seule différence réside dans la nature de l'expression
évaluée, qui est ici une expression XPath et non plus une EL.


--%>

</body>
</html>
