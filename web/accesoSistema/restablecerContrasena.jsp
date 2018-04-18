<html>
    <head>
        <title>Restablecer Contraseña</title>
        <link rel="STYLESHEET" type="text/css" href="<%=(request.getContextPath())%>/css/ventas.css" /> 
        <style type="text/css">
            .tablaRestablecerContrasena{
                width:40%;
                border-collapse: collapse;
                border:1px solid #ccc;
                margin-top: 3rem;
            }
            .tablaRestablecerContrasena td{
                padding: 0.45rem;
            }
            .tablaRestablecerContrasena tfoot td{
                border:1px solid #ccc;
                background-color: #eee;
            }
            .tablaRestablecerContrasena thead td{
                border:1px solid #ccc;
            }
            .ejemplo{
                font-size: 9px;
                color: #aaa;
            }
        </style>
    </head>
    <body>
        <center>
            <form action="guardarEnviarRestablecerContrasena.jsf" method="post">
                <table class="tablaRestablecerContrasena">
                    <thead>
                        <tr><td class="headerClassACliente" colspan="3" style="text-align: center">RESTABLECER CONTRASEÑA</td></tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td class="outputText2" style="font-weight:bold">Nombre de Usuario</td>
                            <td class="outputText2" style="font-weight:bold">:</td>
                            <td ><input type="text" class="inputText" name="nombreUsuario" placeHolder="Nombre de Usuario"/></td>
                        </tr>
                        <tr>
                            <td class="outputText2" style="font-weight:bold">Correo corporativo</td>
                            <td class="outputText2" style="font-weight:bold">:</td>
                            <td >
                                <input type="text" class="inputText" name="correoCorporativo" style="width:100%" placeHolder="Correo corporativo"/>
                                <br/><span class="ejemplo">Ejemplo:usuario@cofar.com.bo</span>
                            </td>
                        </tr>
                        <tr>
                            <td class="outputText2" style="font-weight:bold">Carnet de Identidad</td>
                            <td class="outputText2" style="font-weight:bold">:</td>
                            <td >
                                <input type="text" class="inputText" name="carnetIdentidad" placeHolder="Carnet de Identidad"/>
                                <br/><span class="ejemplo">Ejemplo:3454321 LP</span>
                            </td>
                        </tr>
                        <tfoot>
                            <tr>
                                <td colspan="3">
                                    <center>
                                        <input type="submit" class="btn" value="Restaurar Contraseña"/></a>
                                        <a class="btn" onclick="window.location.href='../login.jsf'">Volver</a>
                                    </center>
                                </td>
                            </tr>
                        </tfoot>
                    </tbody>
                </table>
            </form>
        </center>

    </body>
</html>


