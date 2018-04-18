
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.cofar.util.Util"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.SQLException"%>
<html>
    <head>
        <title>Restablecer Contraseña</title>
        <link rel="STYLESHEET" type="text/css" href="<%=(request.getContextPath())%>/css/ventas.css" /> 
        <style type="text/css">
            .tablaRestablecerContrasena{
                border-collapse: collapse;
                border:1px solid #ccc;
                margin-top: 3rem;
                width: 50%;
                
            }
            .tablaRestablecerContrasena td{
                padding: 0.45rem;
            }
            .tablaRestablecerContrasena tfoot td{
                border:1px solid #ccc;
                background-color: #eee;
                text-align: center;
            }
            .tablaRestablecerContrasena thead td{
                border:1px solid #ccc;
                text-align: center;
            }
            .ejemplo{
                font-size: 9px;
            }
        </style>
    </head>
    <body>
        <center>
            <table class="tablaRestablecerContrasena">
                <%
                    System.out.println("--------------------------------INICIO RESTABLECER CONTRASEÑA----------------------------------");
                    String nombreUsuario = request.getParameter("nombreUsuario");
                    String correoCorporativo = request.getParameter("correoCorporativo");
                    String carnetIdentidad = request.getParameter("carnetIdentidad");
                    System.out.println("nombre usuario: " + nombreUsuario);
                    System.out.println("correo corporativo: " + correoCorporativo);
                    System.out.println("carnet de identidad: " + carnetIdentidad);
                    String claveAccesoCambio = (new SimpleDateFormat("dd/MM/yyyy HH:mm:ss")).format(new Date())+"-"+nombreUsuario;
                    
                    Connection con = null;
                    try{
                        con = Util.openConnection(con);
                        StringBuilder consulta = new StringBuilder("select um.COD_PERSONAL,p.CORREO_EMPRESA,p.NOMBRES_PERSONAL+' '+isnull(p.AP_PATERNO_PERSONAL,'')+' '+p.AP_MATERNO_PERSONAL as nombrePersonal,p.SEXO_PERSONAL")
                                                            .append(" from USUARIOS_MODULOS um")
                                                                    .append(" inner join personal p on p.COD_PERSONAL = um.COD_PERSONAL")
                                                            .append(" where um.NOMBRE_USUARIO =?")
                                                                    .append(" and p.CI_PERSONAL = ?")
                                                                    .append(" and p.CORREO_EMPRESA = ?")
                                                                    .append(" and um.COD_ESTADO_REGISTRO =1");
                        PreparedStatement pst = con.prepareStatement(consulta.toString());
                        pst.setString(1,nombreUsuario);
                        pst.setString(2,carnetIdentidad);
                        pst.setString(3,correoCorporativo);
                        ResultSet res = pst.executeQuery();
                        if(res.next()){
                            char[] CONSTS_HEX = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };
                            MessageDigest msgd = MessageDigest.getInstance("MD5");
                            byte[] bytes = msgd.digest(claveAccesoCambio.getBytes());
                            StringBuilder textoEncriptado = new StringBuilder(2 * bytes.length);
                            for (int i = 0; i < bytes.length; i++){
                                int bajo = (int)(bytes[i] & 0x0f);
                                int alto = (int)((bytes[i] & 0xf0) >> 4);
                                textoEncriptado.append(CONSTS_HEX[alto]);
                                textoEncriptado.append(CONSTS_HEX[bajo]);
                            }
                            claveAccesoCambio = textoEncriptado.toString();
                            out.println("<thead><tr><td colspan='2' class='headerClassACliente'>Verificación Correcta</td></tr></thead>");
                            out.println(" <tbody>");
                            try{
                                StringBuilder correoNoificacion = new StringBuilder("<html><head><style type ='text/css'>body{font-family: Verdana, Arial, Helvetica, sans-serif;color:#5a5959;font-size:12px}</style></head><body>")
                                                                    .append("<p>Estimad"+(res.getInt("SEXO_PERSONAL") ==1 ?"o":"a")+" "+res.getString("nombrePersonal")+" :<br/></p>")
                                                                    .append("<p>Se ha realizado una solicitud para <b>restablecer la contraseña</b> de su cuenta en los sistemas.</p>")
                                                                    .append("<p>Ahora puede realizar el cambio de su contraseña haciendo clic en este enlace o copiándolo y pegándolo en su navegador:</p>")
                                                                    .append("http://").append(request.getLocalAddr()).append(":").append(request.getLocalPort()).append(request.getContextPath()).append("/accesoSistema/completarCambiarContrasenia.jsf?sessionId=").append(claveAccesoCambio)
                                                                    .append("<p>Este enlace solo se puede usar una vez y lo llevará a una página donde puede establecer su nueva contraseña. Caduca terminando el día y no pasará nada si no se usa.</p>")
                                                                    .append("<p>Saludos Coordiales<br/>Equipo de sistemas</p>")
                                                                    .append("</body></html>");
                                InternetAddress emails[] = new InternetAddress[1];
                                System.out.println("enviando a correo: "+res.getString("CORREO_EMPRESA").trim());
                                emails[0] = new InternetAddress(res.getString("CORREO_EMPRESA").trim());
                                Properties props = new Properties();
                                props.put("mail.smtp.host", "host2.cofar.com.bo");
                                props.put("mail.transport.protocol", "smtp");
                                props.put("mail.smtp.auth", "false");
                                props.setProperty("mail.user", "traspasos@cofar.com.bo");
                                props.setProperty("mail.password", "n3td4t4");
                                Session mailSession = Session.getInstance(props, null);
                                Message msg = new MimeMessage(mailSession);
                                msg.setSubject("Restablecimiento de clave de acceso");
                                msg.setFrom(new InternetAddress("traspasos@cofar.com.bo", ""));
                                msg.addRecipients(Message.RecipientType.TO, emails);
                                msg.setContent(correoNoificacion.toString(), "text/html");
                                javax.mail.Transport.send(msg);
                            }
                            catch(Exception ex){
                                ex.printStackTrace();
                                out.println("<tr><td colspan='2'><p style='color:red'>Ocurrio un error, no se tiene comunicación con el servidor de correo, favor notificar a sistemas.</p></td></tr>");
                            }
                            
                            consulta = new StringBuilder("UPDATE USUARIOS_MODULOS SET CLAVE_CAMBIAR_CONTRASENIA_GET=?")
                                                .append(" where COD_PERSONAL = ").append(res.getInt("COD_PERSONAL"));
                            System.out.println("consulta inactivar clave de cambio de acceso");
                            pst = con.prepareStatement(consulta.toString());
                            pst.setString(1,claveAccesoCambio);
                            if(pst.executeUpdate() > 0)System.out.println("se inhabilito la clade cambio de contraseña");
                            
                            out.println("<tr><td><img src='ok.gif' style='width:50px'/></td>"
                                            + "<td>"
                                            +" <span class='outputText2'>Los datos ingresados fueron verificados correctamente.<br/>Revise su cuenta de correo electrónico y siga las instrucciones para culminar con el proceso.</span>"
                                            +" </td></tr></tbody>");
                        }
                        else{
                            out.println("<thead><tr><td colspan='2' class='headerClassACliente'>Datos Incorrectos</td></tr></thead>");
                            out.println("<tbody><tr><td><img src='notOk.gif' style='width:50px'/></td>"
                                    + "<td><span class='outputText2'>Los datos ingresados no corresponden a un usuario habilitado en sistema.</span></td></tr></tbody>");
                        }
                    }   
                    catch(SQLException ex){
                        ex.printStackTrace();
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                    finally{
                        con.close();
                    }
                    System.out.println("--------------------------------FIN RESTABLECER CONTRASEÑA----------------------------------");
                %>
                <tfoot>
                    <tr>
                        <td colspan="2">
                            <a class='btn' onclick="window.location.href='restablecerContrasena.jsf?data='+(new Date()).getTime().toString()">Volver</a>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </center>

    </body>
</html>


