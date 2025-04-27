<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../includes/head.jsp" />
</head>
<body>
    <header>
        <jsp:include page="../includes/header.jsp" />
    </header>
    <aside>
        <jsp:include page="../includes/sidebar.jsp" />
    </aside>
    <main>
        <div class="container">
            <jsp:include page="${pageContent}" />
        </div>
    </main>
    
    <footer>
        <jsp:include page="../includes/footer.jsp" />
    </footer>
</body>
</html>
