<html>
    <head>
        <title>Acceso Denegado</title>
        <link rel="STYLESHEET" type="text/css" href="<%=(request.getContextPath())%>/css/errorPages.css" /> 
    </head>
    <body>
        <center>
        <h3 class="titulo">Acceso Denegado</h3>
        <p class="contenido">
            Su tiempo de sesión termino
            <br/>
            <a href="<%=(request.getContextPath())%>/login.jsf">click para volver a ingresar</a>
        </p>
        
        </center>

    </body>
</html>


