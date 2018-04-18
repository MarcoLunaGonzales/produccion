<%@page import="java.util.Date"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.cofar.util.Util"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
    <%
        Connection con = null;
        String sessionId = request.getParameter("sessionId");
        try{
            con = Util.openConnection(con);
            StringBuilder consulta = new StringBuilder("SELECT u.NOMBRE_USUARIO,u.COD_PERSONAL")
                                                .append(" FROM USUARIOS_MODULOS U ")
                                                .append(" WHERE U.CLAVE_CAMBIAR_CONTRASENIA_GET =?");
            PreparedStatement pst = con.prepareStatement(consulta.toString());
            pst.setString(1,sessionId);
            ResultSet res = pst.executeQuery();
            int codPersonal =0;
            String claveCambioPost="";
            if(res.next() && sessionId.trim().length() >5){
                codPersonal = res.getInt("COD_PERSONAL");
                claveCambioPost = res.getString("NOMBRE_USUARIO")+"/"+res.getInt("COD_PERSONAL")+"/"+(new Date()).getTime();
                char[] CONSTS_HEX = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };
                MessageDigest msgd = MessageDigest.getInstance("MD5");
                byte[] bytes = msgd.digest(claveCambioPost.getBytes());
                StringBuilder textoEncriptado = new StringBuilder(2 * bytes.length);
                for (int i = 0; i < bytes.length; i++){
                    int bajo = (int)(bytes[i] & 0x0f);
                    int alto = (int)((bytes[i] & 0xf0) >> 4);
                    textoEncriptado.append(CONSTS_HEX[alto]);
                    textoEncriptado.append(CONSTS_HEX[bajo]);
                }
                claveCambioPost = textoEncriptado.toString();
                out.println("<html>");
                    out.println("<head>");
                        out.println("<meta http-equiv='Expires' content='0'>"
                                    +"<meta http-equiv='Last-Modified' content='0'>"
                                    +"<meta http-equiv='Cache-Control' content='no-cache, mustrevalidate'>"
                                    +"<meta http-equiv='Pragma' content='no-cache'>");
                        out.println("<title>CAMBIO DE CONTRASEÑA</title>");
                        out.println("<link rel='STYLESHEET' type='text/css' href='"+(request.getContextPath())+"/css/ventas.css' /> ");
                        out.println("<script type='text/javascript' src='completarCambiarContrasenia.js'></script>");
                        out.println("<style type='text/css'>"
                                    + ".tablaRestablecerContrasena{border-collapse: collapse;border:1px solid #ccc;margin-top: 3rem;}"
                                    + ".tablaRestablecerContrasena td{padding: 0.45rem;}"
                                    + ".tablaRestablecerContrasena tfoot td{border:1px solid #ccc;background-color: #eee;text-align:center}"
                                    + ".tablaRestablecerContrasena thead td{border:1px solid #ccc;text-align:center}"
                                    +"</style>");
                    out.println("</head>");
                    out.println("<body ><center>");
                        out.println("<form id='formCompletarCambioContrasena' action='guardarCompletarCambioContrasena.jsf' method='post'/>");
                            out.println("<input type='hidden' name='claveCambioPost' value='"+claveCambioPost+"'/>");
                            out.println("<table class='outputText2 tablaRestablecerContrasena'>"
                                            + "<thead><tr><td colspan='3' class='headerClassACliente'>CAMBIO DE CONTRASEÑA</td></tr></thead>"
                                            + "<tbody>"
                                                + "<tr><td><b>Usuario</b></td><td><b>:</b></td><td><input type='hidden' name='codPersonal' value='"+res.getInt("COD_PERSONAL")+"'/>"+res.getString("NOMBRE_USUARIO")+"</td></tr>"
                                                + "<tr><td><b>Nueva Contraseña</b></td><td><b>:</b></td><td><input class='inputText' name='contraseniaNueva' id='contraseniaNueva' type='password' placeHolder='Nueva Contraseña'/></td></tr>"
                                                + "<tr><td><b>Repita la Nueva Contraseña</b></td><td><b>:</b></td><td><input class='inputText' type='password' id='contraseniaNuevaRepite' placeHolder='Repita la Nueva Contraseña'/></td></tr>"
                                            + "</tbody>"
                                            + "<tfoot>"
                                                +"<tr><td colspan='3'><a onclick='guardar_modificaciones()' class='btn' >Cambiar Contraseña</a></td></tr>"
                                            + "</tfoot>"
                                    + "</table>");
                        out.println("</form>");
                    out.println("</body>");
                out.println("</center></html>");
                consulta = new StringBuilder("UPDATE USUARIOS_MODULOS SET CLAVE_CAMBIAR_CONTRASENIA_GET=?")
                                    .append(" where COD_PERSONAL = ").append(codPersonal);
                System.out.println("consulta inactivar clave de cambio de acceso");
                pst = con.prepareStatement(consulta.toString());
                pst.setString(1,claveCambioPost);
                if(pst.executeUpdate() > 0)System.out.println("se inhabilito la clade cambio de contraseña");
            }
            else{
                out.println("<html>");
                    out.println("<head>");
                        out.println("<title>ACCESO INCORRECTO</title>");
                        out.println("<link rel='STYLESHEET' type='text/css' href='"+(request.getContextPath())+"/css/ventas.css' /> ");
                    out.println("</head>");
                    out.println("<body>");
                        out.println("<center>");
                            out.println("<br/><br/><br/><p style='color:red;font-weight:bold'>LA CLAVE DE ACCESO YA FUE UTILIZADA O NO ES VALIDA, VUELVA A SOLICITAR EL CAMBIO DE CONTRASEÑA</p>");
                        out.println("</center>");
                    out.println("</body>");
                out.println("</html>");
            }

        }
        catch(SQLException ex){
            ex.printStackTrace();
        }
        finally{
            con.close();
        }

    %>


