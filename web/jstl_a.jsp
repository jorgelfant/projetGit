<%--
  Created by IntelliJ IDEA.
  User: JORGE
  Date: 1/17/2020
  Time: 1:01 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Title</title>
</head>
<body>

<!--
La JSTL est une bibliothèque, une collection regroupant des balises implémentant des fonctionnalités à des fins générales,
communes aux applications web. Citons par exemple la mise en place de boucles, de tests conditionnels, le formatage des
données ou encore la manipulation de données XML. Son objectif est de permettre au développeur d'éviter l'utilisation de
code Java dans les pages JSP, et ainsi de respecter au mieux le découpage en couches recommandé par le modèle MVC.
En apparence, ces balises ressemblent comme deux gouttes d'eau aux balises JSP que vous avez découvertes dans les
chapitres précédents !
-->

<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                          Lisibilité du code produit
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Un des gros avantages de l'utilisation des balises JSTL, c'est sans aucun doute la lisibilité du code, et donc sa
maintenabilité. Un exemple étant bien plus parlant que des mots, voici une simple boucle dans une JSP, d'abord en Java
(à base de scriptlet donc), puis via des balises JSTL. Ne vous inquiétez pas de voir apparaître des notations qui vous
sont, pour le moment, inconnues : les explications viendront par la suite.

Une boucle avec une scriptlet Java
**********************************
-->

<%
    List<Integer> list = (ArrayList<Integer>) request.getAttribute("tirage");
    for (int i = 0; i < list.size(); i++) {
        out.print(list.get(i));
    }
%>

<!--
La même boucle avec des tags JSTL
**********************************
-->
<c:forEach var="item" items="${tirage}">
    <c:out value="${item}"/>
</c:forEach>

<!--
Moins de code à écrire
Un autre gros avantage de l'utilisation des balises issues des bibliothèques standard est la réduction de la quantité
de code à écrire. En effet, moins vous aurez à écrire de code, moins vous serez susceptibles d'introduire des erreurs
dans vos pages. La syntaxe de nombreuses actions est simplifiée et raccourcie en utilisant la JSTL, ce qui permet
d'éviter les problèmes dus à des fautes de frappe ou d'inattention dans des scripts en Java.

 Les principaux inconvénients des scriptlets sont les suivants :

1) Réutilisation : il est impossible de réutiliser une scriptlet dans une autre page, il faut la dupliquer. Cela
signifie que lorsque vous avez besoin d'effectuer le même traitement dans une autre page JSP, vous n'avez pas d'autre
choix que de recopier le morceau de code dans l'autre page, et ce pour chaque page nécessitant ce bout de code. La
duplication de code dans une application est, bien entendu, l'ennemi du bien : cela compromet énormément la maintenance
de l'application.

2) Interface : il est impossible de rendre une scriptlet abstract.

3) POO : il est impossible dans une scriptlet de tirer parti de l'héritage ou de la composition.

4) Debug : si une scriptlet envoie une exception en cours d'exécution, tout s'arrête et l'utilisateur récupère une
page blanche…

5) Tests : on ne peut pas écrire de tests unitaires pour tester les scriptlets. Lorsqu'un développeur travaille sur une
application relativement large, il doit s'assurer que ses modifications n'impactent pas le code existant et utilise pour
cela une batterie de tests dits "unitaires", qui ont pour objectif de vérifier le fonctionnement des différentes méthodes
implémentées. Eh bien ceux-ci ne peuvent pas s'appliquer au code Java écrit dans une page JSP : là encore, cela compromet
énormément la maintenance et l'évolutivité de l'application.

6) Maintenance : inéluctablement, il faut passer énormément plus de temps à maintenir un code mélangé, encombré, dupliqué
et non testable !

Si vous ne deviez retenir qu'une phrase de tout cela, c'est que bafouer MVC en écrivant du code Java directement dans
une JSP rend la maintenance d'une application extrêmement compliquée, et par conséquent réduit fortement son évolutivité.
Libre à vous par conséquent de décider de l'avenir que vous souhaitez donner à votre projet, en suivant ou non les
recommandations.

Dernière couche : on écrit du code Java directement dans une JSP uniquement lorsqu'il nous est impossible de faire
autrement, ou lorsque l'on désire vérifier un fonctionnement via une simple feuille de tests ; et enfin pourquoi pas
lorsque l'on souhaite rapidement écrire un prototype temporaire afin de se donner une idée du fonctionnement d'une
application de très faible envergure. Voilà, j'espère que maintenant vous l'avez bien assimilé, ce n'est pas faute de
vous l'avoir répété…

Plusieurs versions
******************

La JSTL a fait l'objet de plusieurs versions :

JSTL 1.0 pour la plate-forme J2EE 3, et un conteneur JSP 1.2 (ex: Tomcat 4) ;

JSTL 1.1 pour la plate-forme J2EE 4, et un conteneur JSP 2.0 (ex: Tomcat 5.5) ;

JSTL 1.2, qui est partie intégrante de la plate-forme Java EE 6, avec un conteneur JSP 2.1 ou 3.0 (ex: Tomcat 6 et 7).

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                             CONFIGURATION
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Configuration de la JSTL
************************

Il y a plusieurs choses que vous devez savoir ici. Plutôt que de vous donner tout de suite les solutions aux problèmes
qui vous attendent, fonçons têtes baissées, et je vous guiderai lorsque cela s’avérera nécessaire. On apprend toujours
mieux en faisant des erreurs et en apprenant à les corriger, qu'en suivant bêtement une série de manipulations.

D'erreur en erreur…
*******************
Allons-y gaiement donc, et tentons naïvement d'insérer une balise JSTL ni vu ni connu dans notre belle et vierge page JSP :

-->

<c:out value="" />
</body>
</html>

<!--
Il ne vous reste plus qu'à démarrer votre Tomcat si ce n'est pas déjà fait, et à vérifier que tout se passe bien,
en accédant à votre JSP depuis votre navigateur via l'adresse http://localhost:8080/TestJSTL/test.jsp. Le mot "test"
devrait alors s'afficher : félicitations, vous venez de mettre en place et utiliser avec succès votre premier tag JSTL !

la JSTL est composée de cinq bibliothèques de balises standard ;
-->
