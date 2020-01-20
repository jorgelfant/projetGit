<%--
  Created by IntelliJ IDEA.
  User: JORGE
  Date: 1/18/2020
  Time: 8:29 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<p>
    <%-- Affiche les différentes sous-chaînes séparées par une virgule ou un point-virgule --%>
    <c:forTokens var="sousChaine" items="salut; je suis un,gros;zéro+!" delims=";,+">
        ${sousChaine}<br/>
    </c:forTokens>

    <%--
         Affiche les différentes sous-chaînes séparées par une virgule ou un point-virgule

        <c:forTokens var="sousChaine" items="salut; je suis un,gros;zéro+!" delims=";,+">
            <c:out value="${sousChaine}"/><br/>
        </c:forTokens>
    --%>
</p>
</body>
</html>
