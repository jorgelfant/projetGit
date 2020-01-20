<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Title</title>
</head>
<>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            La bibliothèque Core
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Nous voici prêts à étudier la bibliothèque Core, offrant des balises pour les principales actions nécessaires dans la
couche présentation d'une application web. Ce chapitre va en quelque sorte faire office de documentation : je vais vous
y présenter les principales balises de la bibliothèque, et expliciter leur rôle et comportement via des exemples simples.

Lorsque ces bases seront posées, nous appliquerons ce que nous aurons découvert ici dans un TP. S'il est vrai que l'on
ne peut se passer de la théorie, pratiquer est également indispensable si vous souhaitez assimiler et progresser. ;)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                            Les variables et expressions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Pour commencer, nous allons apprendre comment afficher le contenu d'une variable ou d'une expression, et comment gérer
une variable et sa portée. Avant cela, je vous donne ici la directive JSP nécessaire pour permettre l'utilisation des
balises de la bibliothèque Core dans vos pages :

               <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

Cette directive devra être présente sur chacune des pages de votre projet utilisant les balises JSTL que je vous présente
dans ce chapitre. Dans un prochain chapitre, nous verrons comment il est possible de ne plus avoir à se soucier de cette
commande. En attendant, ne l'oubliez pas !

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                           Affichage d'une expression
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

La balise utilisée pour l'affichage est <c:out value="" />. Le seul attribut obligatoirement requis pour ce tag est
value. Cet attribut peut contenir une chaîne de caractères simple, ou une expression EL. Voici quelques exemples :

À celui-ci s'ajoutent deux attributs optionnels :

default : permet de définir une valeur affichée par défaut si le contenu de l'expression évaluée est vide ;

escapeXml : permet de remplacer les caractères de scripts < , > , " , ' et & par leurs équivalents en
code html &lt;, &gt;, &#034;, &#039;, &amp;. Cette option est activée par défaut, et vous devez expliciter
<c:out ... escapeXml="false" /> pour la désactiver.
--%>
<c:out value="test"/> <%-- Affiche test --%>
<c:out value="${ 'a' < 'b' }"/> <%-- Affiche true --%>
<c:out value="${param.lang}" default="message par defaut car value sera vide"/> <%-- Affiche FR si value est vide--%>


<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                Pourquoi utiliser une balise pour afficher simplement du texte ou une expression ?
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

C'est une question légitime. Après tout c'est vrai, pourquoi ne pas directement écrire le texte ou l'expression dans
notre page JSP ? Pourquoi s'embêter à inclure le texte ou l'expression dans cette balise ? Eh bien la réponse se trouve
dans l'explication de l'attribut optionnel escapeXml : celui-ci est activé par défaut ! Cela signifie que l'utilisation
de la balise <c:out> permet d'échapper automatiquement les caractères spéciaux de nos textes et rendus d'expressions,
et c'est là une excellente raison d'utilisation (voir ci-dessous l'avertissement concernant les failles XSS).

Voici des exemples d'utilisation de l'attribut default :

--%>
<%-- 1) Cette balise affichera le mot 'test si le bean n'existe pas' --%>
<c:out value="${bean}">
    test
</c:out>

<%-- 2) Cette balise affichera le mot 'test si le bean n'existe pas' --%>
<c:out value="${bean}" default="test"/>

<%-- Et il est interdit d'écrire :

                                     <c:out value="${bean}" default="test">
                                         une autre chaine
                                     </c:out>

--%>

<%--
Pour le dernier cas, l'explication est simple : l'attribut default jouant déjà le rôle de valeur par défaut, le corps
du tag ne peut exister que lorsqu'aucune valeur par défaut n'est définie. Pour information, Eclipse vous signalera une
erreur si vous tentez d'écrire la balise sous cette forme.

Pour en finir avec cette balise, voici un exemple d'utilisation de l'attribut escapeXml :
--%>

<%-- Sans préciser d'attribut escapeXml : --%>
<c:out value="<p>Je suis un 'paragraphe'.</p>"/>

<%-- La balise affichera : --%>
<%--    &lt;p&gt;Je suis un &#039;paragraphe&#039;.&lt;/p&gt;       --%>

<%-- Et en précisant l'attribut à false :--%>
<c:out value="<p>Je suis un 'paragraphe2'.</p>" escapeXml="false"/>

<%-- La balise affichera : --%>
<%--    <p>Je suis un 'paragraphe'.</p>       --%>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Vous pouvez constater dans cet exemple l'importance de l'activation par défaut de l'option escapeXml : elle empêche
l'interprétation de ce qui est affiché par le navigateur, en modifiant les éléments de code HTML présents dans le
contenu traité (en l'occurrence les caractères <, > et ').
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Vous devez prendre l'habitude d'utiliser ce tag JSTL lorsque vous affichez des variables, notamment lorsqu'elles sont
récupérées depuis le navigateur, c'est-à-dire lorsqu'elles sont saisies par l'utilisateur. Prenons l'exemple d'un
formulaire :
--%>
<%-- Mauvais exemple --%>
<input type="text" name="donnee" value="${donneeSaisieParUnUtilisateur}"/>

<%-- Bon exemple --%>
<input type="text" name="donnee" value="<c:out value="${donneeSaisieParUnUtilisateur}"/>"/>

<%--
Nous le découvrirons plus tard, mais sachez que les données récupérées depuis un formulaire sont potentiellement
dangereuses, puisqu'elles permettent des attaques de type XSS ou d'injection de code. L'utilisation du tag <c:out>
permet d'échapper les caractères spéciaux responsables de cette faille, et ainsi de prévenir tout risque à ce niveau.
Ne vous posez pas trop de questions au sujet de cet exemple, nous reviendrons en détail sur cette faille dans le
chapitre sur les formulaires.
--%>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      Gestion d'une variable
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Avant de parler variable, revenons sur leur portée ! La portée (ou visibilité) d'une variable correspond concrètement
à l'endroit dans lequel elle est stockée, et par corollaire aux endroits depuis lesquels elle est accessible. Selon la
portée affectée à votre variable, elle sera par exemple accessible depuis toute votre application, ou seulement depuis
une page particulière, etc. Il y a quatre portées différentes (ou scopes en anglais), que vous connaissez déjà et
redécouvrirez au fur et à mesure des exemples de ce chapitre :

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                               Création
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

La balise utilisée pour la création d'une variable est <c:set>. Abordons pour commencer la mise en place d'un attribut
dans la requête. En JSP/servlets, vous savez tous faire ça, mais qu'en est-il avec la JSTL ? Il suffit d'utiliser les
trois attributs suivants : var, value et scope.

--%>
<%-- Cette balise met l'expression "Salut les zéros !" dans l'attribut "message" de la requête : --%>
<c:set var="message" value="Salut les zéros !" scope="request"/>
<%-- Et est l'équivalent du scriplet Java suivant : --%>
<% request.setAttribute("message", "Salut les zéros !"); %>

<%--
L'attribut var contient le nom de la variable que l'on veut stocker, value sa valeur, et scope la portée de cette
variable. Simple, rapide et efficace ! Voyons maintenant comment récupérer cette valeur pour l'afficher à l'utilisateur,
par exemple :

Affiche l'expression contenue dans la variable "message" de la requête
**********************************************************************
--%>
<br>
<c:out value="${requestScope.message}"/>

<%--
Vous remarquerez que nous utilisons ici dans l'expression EL l'objet implicite requestScope, qui permet de rechercher
un objet dans la portée requête uniquement. Les plus avertis d'entre vous ont peut-être tenté d'accéder à la valeur
fraîchement créée via un simple <c:out value="${ message }"/>. Et effectivement, dans ce cas cela fonctionne également.
Pourquoi ?

Nous retrouvons ici une illustration du mécanisme dont je vous ai parlé lorsque nous avons appliqué les EL dans notre
code d'exemple. Par défaut, si le terme de l'expression n'est ni un type primitif (int, char, boolean, etc.) ni un objet
implicite de la technologie EL, l'expression va d'elle-même chercher un attribut correspondant à ce terme dans les
différentes portées de votre application : page, puis request, puis session et enfin application.

Souvenez-vous : je vous avais expliqué que c'est grâce à l'objet implicite pageContext que le mécanisme parcourt toutes
les portées, et qu'il renvoie alors automatiquement le premier objet trouvé lors de son parcours. Voilà donc pourquoi
cela fonctionne avec la seconde écriture : puisque nous ne précisons pas de portée, l'expression EL les parcourt
automatiquement une par une jusqu'à ce qu'elle trouve un objet nommé message, et nous le renvoie !

N'oubliez pas : la bonne pratique veut que vous ne donniez pas le même nom à deux variables différentes, présentes dans
des portées différentes. Toutefois, afin d'éviter toute confusion si jamais des variables aux noms identiques venaient
à coexister, il est également conseillé de n'utiliser la seconde écriture que lorsque vous souhaitez faire référence à
des attributs de portée page, et d'utiliser la première écriture que je vous ai présentée pour le reste (session,
request et application).

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        Modification
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

La modification d'une variable s'effectue de la même manière que sa création. Ainsi, le code suivant créera une variable
nommée "maVariable" si elle n'existe pas déjà, et initialisera son contenu à "12" :

--%>

<%-- L'attribut scope n'est pas obligatoire. Rappelez-vous, le scope par défaut est dans ce cas la page,
puisque c'est le premier dans la liste des scopes parcourus --%>
<c:set var="maVariable" value="12"/>

<%--
Pour information, il est également possible d'initialiser une variable en utilisant le corps de la balise,
plutôt qu'en utilisant l'attribut value :
--%>
<c:set var="taVariable">12</c:set>

<%--
À ce sujet, sachez d'ailleurs qu'il est possible d'imbriquer d'autres balises dans le corps de cette balise, et pas
seulement d'utiliser de simples chaînes de caractères ou expressions. Voici par exemple comment vous pourriez initialiser
la valeur d'une variable de session depuis une valeur lue dans un paramètre de l'URL :
--%>
<%--     <c:set var="locale" value="<c:out value='${param.lang}'/>" scope="session"/>            --%>
<c:set var="locale" scope="session">
    <c:out value="${param.lang}" default="FR"/>
</c:set>

<%--
Plusieurs points importants ici :

  * vous constatez bien ici l'utilisation de la balise <c:out> à l'intérieur du corps de la balise <c:set> ;

  * vous pouvez remarquer l'utilisation de l'objet implicite param, pour récupérer la valeur du paramètre de la requête
    nommé lang ;

  * si le paramètre lang n'existe pas ou s'il est vide, c'est la valeur par défaut "FR" spécifiée dans notre balise <c:out>
    qui sera utilisée pour initialiser notre variable en session.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     Modification des propriétés d'un objet
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Certains d'entre vous se demandent probablement comment il est possible de définir ou modifier une valeur particulière
lorsqu'on travaille sur certains types d'objets... Et ils ont bien raison ! En effet, avec ce que je vous ai présenté
pour le moment, vous êtes capables de définir une variable de n'importe quel type, type qui est défini par l'expression
que vous écrivez dans l'attribut value du tag <c:set> :
--%>

<%-- Crée un objet de type String --%>
<c:set scope="session" var="description" value="Je suis une loutre."/>

<%-- Crée un objet du type du bean ici spécifié dans l'attribut 'value'--%>
<c:set scope="session" var="tonBean" value="${monBean}"/>

<%--
Et c'est ici que vous devez vous poser la question suivante : comment modifier les propriétés du bean créé dans cet
exemple ? En effet, il vous manque deux attributs pour y parvenir ! Regardons donc de plus près quels sont ces attributs,
et comment ils fonctionnent :

  * target : contient le nom de l'objet dont la propriété sera modifiée ;

  * property : contient le nom de la propriété qui sera modifiée.
 --%>

<!-- Définir ou modifier la propriété 'prenom' du bean 'coyote' -->
<c:set target="${coyote}" property="prenom" value="Wile E."/>

<!-- Définir ou modifier la propriété 'prenom' du bean 'coyote' via le corps de la balise -->
<c:set target="${coyote}" property="prenom">
    Wile E.
</c:set>

<!-- Passer à null la valeur de la propriété 'prenom' du bean 'coyote' -->
<c:set target="${coyote}" property="prenom" value="${null}"/>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                 Suppression
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Dernière étape : supprimer une variable. Une balise est dédiée à cette tâche, avec pour seul attribut requis var.
Par défaut toujours, c'est le scope page qui sera parcouru si l'attribut scope n'est pas explicité :
--%>

<%-- Supprime la variable "maVariable" de la session --%>
<c:remove var="maVariable" scope="session"/>

<%--
Voilà déjà un bon morceau de fait ! Ne soyez pas abattus si vous n'avez pas tout compris lorsque nous avons utilisé
des objets implicites. Nous y reviendrons de toute manière quand nous en aurons besoin dans nos exemples, et vous
comprendrez alors avec la pratique.
--%>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                             Les conditions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Une condition simple
********************

La JSTL fournit deux moyens d'effectuer des tests conditionnels. Le premier, simple et direct, permet de tester une
seule expression, et correspond au bloc if() du langage Java. Le seul attribut obligatoire est test.
--%>

<c:if test="${ 12 > 7 }" var="maVariable" scope="session">
    Ce test est vrai.
</c:if>

<%--
Ici, le corps de la balise est une simple chaîne de caractères. Elle ne sera affichée dans la page finale que si la
condition est vraie, à savoir si l'expression contenue dans l'attribut test renvoie true. Ici, c'est bien entendu le
cas, 12 est bien supérieur à 7. ^^

Les attributs optionnels var et scope ont ici sensiblement le même rôle que dans la balise <c:set>. Le résultat du test
conditionnel sera stocké dans la variable et dans le scope défini, et sinon dans le scope page par défaut. L'intérêt
de cette utilisation réside principalement dans le stockage des résultats de tests coûteux, un peu à la manière d'un
cache, afin de pouvoir les réutiliser en accédant simplement à des variables de scope.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                         Des conditions multiples
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

La seconde méthode fournie par la JSTL est utile pour traiter les conditions mutuellement exclusives, équivalentes en
Java à une suite de if() / else if() ou au bloc switch(). Elle est en réalité constituée de plusieurs balises :
--%>
<c:choose>
    <c:when test="${expression}">Action ou texte.</c:when>
    ...
    <c:otherwise>Autre action ou texte.</c:otherwise>
</c:choose>

<%--
La balise <c:choose> ne peut contenir aucun attribut, et son corps ne peut contenir qu'une ou plusieurs balises
<c:when> et une ou zéro balise <c:otherwise>.

La balise <c:when> ne peut exister qu'à l'intérieur d'une balise <c:choose>. Elle est l'équivalent du mot-clé case
en Java, dans un bloc switch(). Tout comme la balise <c:if>, elle doit obligatoirement se voir définir un attribut
test contenant la condition. À l'intérieur d'un même bloc <c:choose>, un seul <c:when> verra son corps évalué, les
conditions étant mutuellement exclusives.

La balise <c:otherwise> ne peut également exister qu'à l'intérieur d'une balise <c:choose>, et après la dernière
balise <c:when>. Elle est l'équivalent du mot-clé default en Java, dans un bloc switch(). Elle ne peut contenir
aucun attribut, et son corps ne sera évalué que si aucune des conditions la précédant dans le bloc n'est vérifiée.

Voilà pour les conditions avec la JSTL. Je ne pense pas qu'il soit nécessaire de prendre plus de temps ici, la principale
différence avec les conditions en Java étant la syntaxe utilisée.
--%>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                 Les boucles
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Abordons à présent la question des boucles. Dans la plupart des langages, les boucles ont une syntaxe similaire :
for, while, do/while... Avec la JSTL, deux choix vous sont offerts, en fonction du type d'élément que vous souhaitez
parcourir avec votre boucle : <c:forEach> pour parcourir une collection, et <c:forTokens> pour parcourir une chaîne
de caractères.

Boucle "classique"
******************

Prenons pour commencer une simple boucle for en scriptlet Java, affichant un résultat formaté dans un tableau HTML
par exemple :
--%>
<%-- Boucle calculant le cube des entiers de 0 à 7 et les affichant dans un tableau HTML --%>
<table>
    <tr>
        <th>Valeur</th>
        <th>Cube</th>
    </tr>

    <%
        int[] cube = new int[8];
        /* Boucle calculant et affichant le cube des entiers de 0 à 7 */
        for (int i = 0; i < 8; i++) {
            cube[i] = i * i * i;
            out.print("<tr><td>" + i + "</td> <td>" + cube[i] + "</td></tr>");
        }
    %>

</table>


<%--
Avec la JSTL, si l'on souhaite réaliser quelque chose d'équivalent, il faudrait utiliser la syntaxe suivante :
--%>

<%-- Boucle calculant le cube des entiers de 0 à 7 et les affichant dans un tableau HTML --%>
<table>
    <tr>
        <th>Valeur</th>
        <th>Cube</th>
    </tr>

    <c:forEach var="i" begin="0" end="7" step="1">
        <tr>
            <td><c:out value="${i}"/></td>
            <td><c:out value="${i * i * i}"/></td>
        </tr>
    </c:forEach>

</table>

<%--
Avant tout, on peut déjà remarquer la clarté du second code par rapport au premier : les balises JSTL s'intègrent très
bien au formatage HTML englobant les résultats. On devine rapidement ce que produira cette boucle, ce qui était bien
moins évident avec le code en Java, pourtant tout aussi basique. Étudions donc les attributs de cette fameuse boucle :

begin : la valeur de début de notre compteur (la valeur de i dans la boucle en Java, initialisée à zéro en l'occurrence) ;

end : la valeur de fin de notre compteur. Vous remarquez ici que la valeur de fin est 7 et non pas 8, comme c'est le
cas dans la boucle Java. La raison est simple : dans la boucle Java en exemple j'ai utilisé une comparaison stricte
(i strictement inférieur à 8), alors que la boucle JSTL ne procède pas par comparaison stricte (i inférieur ou égal à 7).
J'aurais certes pu écrire i <= 7 dans ma boucle Java, mais je n'ai par contre pas le choix dans ma boucle JSTL,
c'est uniquement ainsi. Pensez-y, c'est une erreur bête mais facile à commettre si l'on oublie ce comportement ;

step : c'est le pas d'incrémentation de la boucle. Concrètement, si vous changez cette valeur de 1 à 3 par exemple,
alors le compteur de la boucle ira de 3 en 3 et non plus de 1 en 1. Par défaut, si vous ne spécifiez pas l'attribut step,
la valeur 1 sera utilisée ;

var : cet attribut est, contrairement à ce qu'on pourrait croire a priori, non obligatoire. Si vous ne le spécifiez pas,
vous ne pourrez simplement pas accéder à la valeur du compteur en cours (via la variable i dans notre exemple).
Vous pouvez choisir de ne pas préciser cet attribut si vous n'avez pas besoin de la valeur du compteur à l'intérieur de
votre boucle. Par ailleurs, tout comme en Java lorsqu'on utilise une syntaxe équivalente à l'exemple précédent
(déclaration de l'entier i à l'intérieur du for), la variable n'est accessible qu'à l'intérieur de la boucle, autrement
dit dans le corps de la balise <c:forEach>.

Vous remarquerez bien évidemment que l'utilisation de tags JSTL dans le corps de la balise est autorisée :
nous utilisons ici dans cet exemple l'affichage via des balises <c:out>.

Voici, mais cela doit vous paraître évident, le code HTML produit par cette page JSP :

                                                     <table>
                                                       <tr>
                                                         <th>Valeur</th>
                                                         <th>Cube</th>
                                                       </tr>
                                                       <tr>
                                                         <td>0</td>
                                                         <td>0</td>
                                                       </tr>
                                                       <tr>
                                                         <td>1</td>
                                                         <td>1</td>
                                                       </tr>
                                                       <tr>
                                                         <td>2</td>
                                                         <td>8</td>
                                                       </tr>
                                                       <tr>
                                                         <td>3</td>
                                                         <td>27</td>
                                                       </tr>
                                                       <tr>
                                                         <td>4</td>
                                                         <td>64</td>
                                                       </tr>
                                                       <tr>
                                                         <td>5</td>
                                                         <td>125</td>
                                                       </tr>
                                                       <tr>
                                                         <td>6</td>
                                                         <td>216</td>
                                                       </tr>
                                                       <tr>
                                                         <td>7</td>
                                                         <td>343</td>
                                                       </tr>
                                                     </table>
--%>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                         Itération sur une collection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Passons maintenant à quelque chose de plus intéressant et utilisé dans la création de pages web : les itérations sur
les collections. Si ce terme ne vous parle pas, c'est que vous avez besoin d'une bonne piqûre de rappel en Java ! Et
ce n'est pas moi qui vous la donnerai, si vous en sentez le besoin, allez faire un tour sur ce chapitre du tuto de Java.

La syntaxe utilisée pour parcourir une collection est similaire à celle d'une boucle simple, sauf que cette fois,
un attribut items est requis. Et pour cause, c'est lui qui indiquera la collection à parcourir. Imaginons ici que nous
souhaitions réaliser l'affichage de news sur une page web. Imaginons pour cela que nous ayons à disposition un ArrayList
ici nommé maListe, contenant simplement des HashMap. Chaque HashMap ici associera le titre d'une news à son contenu.
Nous souhaitons alors parcourir cette liste afin d'afficher ces informations dans une page web :
--%>

<%@ page import="java.util.*" %>
<%
    /* Création de la liste et des données */
    List<Map<String, String>> maListe = new ArrayList<Map<String, String>>();
    Map<String, String> news = new HashMap<String, String>();
    news.put("titre", "Titre de ma première news");
    news.put("contenu", "corps de ma première news");
    maListe.add(news);
    news = new HashMap<String, String>();
    news.put("titre", "Titre de ma seconde news");
    news.put("contenu", "corps de ma seconde news");
    maListe.add(news);
    pageContext.setAttribute("maListe", maListe);
%>

<c:forEach items="${maListe}" var="news">
    <div class="news">
        <div class="titreNews">
            <c:out value="${news['titre']}"/>
        </div>
        <div class="corpsNews">
            <c:out value="${news['contenu']}"/>
        </div>
    </div>
</c:forEach>

<%--
Je sens que certains vont m'attendre au tournant... Eh oui, j'ai utilisé du code Java ! Et du code sale en plus !
Mais attention à ne pas vous y méprendre : je n'ai recours à du code Java ici que pour l'exemple, afin de vous procurer
un moyen simple et rapide pour initialiser des données de test, et afin de vérifier le bon fonctionnement de notre boucle.

Il va de soi que dans une vraie application web, ces données seront initialisées correctement, et non pas comme je
l'ai fait ici. Qu'elles soient récupérées depuis une base de données, depuis un fichier, voire codées en dur dans la
couche métier de votre application, ces données ne doivent jamais et en aucun cas, je répète, elles ne doivent jamais
et en aucun cas, être initialisées directement depuis vos JSP ! Le rôle d'une page JSP, je le rappelle, c'est de
présenter l'information, un point c'est tout. Ce n'est pas pour rien que la couche dans laquelle se trouvent les JSP
s’appelle la couche de présentation.

Revenons à notre boucle : ici, je n'ai pas encombré la syntaxe, en utilisant les seuls attributs items et var. Le
premier indique la collection sur laquelle la boucle porte, en l'occurrence notre List nommée maListe, et le second
indique quant à lui le nom de la variable qui sera liée à l’élément courant de la collection parcourue par la boucle,
que j'ai ici de manière très originale nommée "news", nos HashMap contenant... des news. Ainsi, pour accéder respectivement
aux titres et contenus de nos news, il suffit, via la notation avec crochets, de préciser les éléments visés dans notre
Map, ici aux lignes 19 et 22. Nous aurions très bien pu utiliser à la place des crochets l'opérateur point : ${news.titre}
et ${news.contenu}.

--%>

<div class="news">
    <div class="titreNews">
        Titre de ma première news
    </div>
    <div class="corpsNews">
        corps de ma première news
    </div>
</div>

<div class="news">
    <div class="titreNews">
        Titre de ma seconde news
    </div>
    <div class="corpsNews">
        corps de ma seconde news
    </div>
</div>

<%--
Les attributs présentés précédemment lors de l'étude d'une boucle simple sont là aussi valables : si vous souhaitez
par exemple n'afficher que les dix premières news sur votre page, vous pouvez limiter le parcours de votre liste aux
dix premiers éléments ainsi :
--%>

<c:forEach items="${maListe}" var="news" begin="0" end="9">
    ...
</c:forEach>

<%--
Si les attributs begin et end spécifiés dépassent le contenu réel de la collection, par exemple si vous voulez afficher
les dix premiers éléments d'une liste mais qu'elle n'en contient que trois, la boucle s'arrêtera automatiquement lorsque
le parcours de la liste sera terminé, peu importe l'indice end spécifié.

Simple, n'est-ce pas ? :)

À titre d'information, voici enfin les différentes collections sur lesquelles il est possible d'itérer avec la
boucle <c:forEach> de la bibliothèque Core :

                                            java.util.Collection ;

                                            java.util.Map ;

                                            java.util.Iterator ;

                                            java.util.Enumeration ;

Array d'objets ou de types primitifs ;

(Chaînes de caractères séparées par des séparateurs définis).

Si j'ai mis entre parenthèses le dernier élément, c'est parce qu'il est déconseillé d'utiliser cette boucle pour
parcourir une chaîne de caractères dont les éléments sont séparés par des caractères séparateurs définis. Voyez le
paragraphe suivant pour en savoir plus à ce sujet.

Enfin, sachez qu'il est également possible d'itérer directement sur le résultat d'une requête SQL. Cependant,
volontairement, je n'aborderai pas ce cas, pour deux raisons :

je ne vous ai pas encore présenté la bibliothèque sql de la JSTL, permettant d'effectuer des requêtes SQL depuis vos JSP ;

je ne vous présenterai pas la bibliothèque sql de la JSTL, ne souhaitant pas vous voir effectuer des requêtes SQL depuis
vos JSP !

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                         L'attribut varStatus
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Il reste un attribut que je n'ai pas encore évoqué et qui est, comme les autres, utilisable pour tout type d'itérations,
que ce soit sur des entiers ou sur des collections : l'attribut varStatus. Tout comme l'attribut var, il est utilisé pour
créer une variable de scope, mais présente une différence majeure : alors que var permet de stocker la valeur de l'index
courant ou l'élément courant de la collection parcourue, le varStatus permet de stocker un objet LoopTagStatus, qui
définit un ensemble de propriétés définissant l'état courant d'une itération :

                  Propriété                                   Description
                  ---------------------------------------------------------------------------------------------
                  begin                                       La valeur de l'attribut begin.
                  ---------------------------------------------------------------------------------------------
                  end                                         La valeur de l'attribut end.
                  ---------------------------------------------------------------------------------------------
                  step                                        La valeur de l'attribut step.
                  ---------------------------------------------------------------------------------------------
                  first                                       Booléen précisant si l'itération courante est la première.
                  ---------------------------------------------------------------------------------------------
                  last                                        Booléen précisant si l'itération courante est la dernière.
                  ---------------------------------------------------------------------------------------------
                  count                                       Compteur d'itérations (commence à 1).
                  ---------------------------------------------------------------------------------------------
                  index                                       Index d'itérations (commence à 0).
                  ---------------------------------------------------------------------------------------------
                  current                                     Élément courant de la collection parcourue.

Reprenons l'exemple utilisé précédemment, mais cette fois-ci en mettant en jeu l’attribut varStatus :
--%>

<c:forEach items="${maListe}" var="news" varStatus="status">
    <div class="news">
        News n° <c:out value="${status.count}"/> :
        <div class="titreNews">
            <c:out value="${news['titre']}" />
        </div>
        <div class="corpsNews">
            <c:out value="${news['contenu']}" />
        </div>
    </div>
</c:forEach>

<%--
J'ai utilisé ici la propriété count de l'attribut varStatus, affichée simplement en tant que numéro de news. Cet
exemple est simple, mais suffit à vous faire comprendre comment utiliser cet attribut : il suffit d'appeler directement
une propriété de l'objet varStatus, que j'ai ici de manière très originale nommée... status.

Pour terminer, sachez enfin que l'objet créé par cet attribut varStatus n'est visible que dans le corps de la boucle,
tout comme l'attribut var.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                         Itération sur une chaîne de caractères
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Une variante de la boucle <c:forEach> existe, spécialement dédiée aux chaînes de caractères. La syntaxe est presque
identique :
--%>
<p>
    <%-- Affiche les différentes sous-chaînes séparées par une virgule ou un point-virgule --%>
    <c:forTokens var="sousChaine" items="salut; je suis un,gros;zéro+!" delims=";,+">
        ${sousChaine}<br/>
    </c:forTokens>
</p>

<%--
Un seul attribut apparaît : delims. C'est ici que l'on doit spécifier quels sont les caractères qui serviront de
séparateurs dans la chaîne que la boucle parcourra. Il suffit de les spécifier les uns à la suite des autres, comme
c'est le cas ici dans notre exemple. Tous les autres attributs vus précédemment peuvent également s'appliquer ici
(begin, end, step...).

Le rendu HTML de ce dernier exemple est donc :
--%>
<p>
    salut<br/>
    je suis un<br/>
    gros<br/>
    zero<br/>
    !<br/>
</p>

<%--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                     Ce que la JSTL ne permet pas (encore) de faire
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Il est possible en Java d'utiliser les commandes break et continue pour sortir d'une boucle en cours de parcours. Eh
bien sachez que ces fonctionnalités ne sont pas implémentées dans la JSTL. Par conséquent, il est impossible la plupart
du temps de sortir d'une boucle en cours d'itération.

Il existe dans certains cas des moyens plus ou moins efficaces de sortir d'une boucle, via l'utilisation de conditions
<c:if> notamment. Quant aux cas d'itérations sur des collections, la meilleure solution si le besoin de sortir en cours
de boucle se fait ressentir, est de déporter le travail de la boucle dans une classe Java. Pour résumer, ce genre de
situations se résout au cas par cas, selon vos besoins. Mais n'oubliez pas : votre vue doit se consacrer à l'affichage
uniquement. Si vous sentez que vous avez besoin de fonctionnalités qui n'existent pas dans la JSTL, il y a de grandes
chances pour que vous soyez en train de trop en demander à votre vue, et éventuellement de bafouer MVC !

--%>

</body>
</html>
