<%--
  Created by IntelliJ IDEA.
  User: JORGE
  Date: 1/17/2020
  Time: 3:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Title</title>
</head>
<body>

<c:out value="test" /> <%-- Affiche test --%>
<c:out value="${ 'a' < 'b' }" /> <%-- Affiche true --%>


</body>
</html>
