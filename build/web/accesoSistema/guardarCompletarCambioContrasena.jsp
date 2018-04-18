<%@page import="java.security.MessageDigest"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    
    Connection con=null;
    String codPersonal = request.getParameter("codPersonal");
    String contrasena = request.getParameter("contraseniaNueva");
    String claveCambioPost = request.getParameter("claveCambioPost");
    char[] CONSTS_HEX = { '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' };
    MessageDigest msgd = MessageDigest.getInstance("MD5");
    byte[] bytes = msgd.digest(contrasena.getBytes());
    StringBuilder textoEncriptado = new StringBuilder(2 * bytes.length);
    for (int i = 0; i < bytes.length; i++){
        int bajo = (int)(bytes[i] & 0x0f);
        int alto = (int)((bytes[i] & 0xf0) >> 4);
        textoEncriptado.append(CONSTS_HEX[alto]);
        textoEncriptado.append(CONSTS_HEX[bajo]);
    }
    contrasena = textoEncriptado.toString();
    String mensaje="";
    boolean transaccionExistosa = false;
    String urlLogin =" http://"+request.getLocalAddr()+":"+request.getLocalPort()+request.getContextPath()+"/login.jsf";
    try
    {
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder(" update usuarios_modulos set CLAVE_CAMBIAR_CONTRASENIA_GET =''");
                                            consulta.append(" ,contrasena_usuario = ?");
                                            consulta.append(" ,FECHA_VENCIMIENTO = DATEADD(MONTH,3,GETDATE())");
                                    consulta.append(" WHERE COD_PERSONAL=").append(codPersonal);
                                            consulta.append(" and CLAVE_CAMBIAR_CONTRASENIA_GET = ?");
        System.out.println("consulta cambiar contrasenia usuario "+consulta.toString());
        PreparedStatement pst=con.prepareStatement(consulta.toString());
        pst.setString(1,contrasena);System.out.println("p1: "+contrasena);
        pst.setString(2,claveCambioPost);System.out.println("p2: "+claveCambioPost);
        if(pst.executeUpdate()>0){
            System.out.println("se guardo el cambio de contrasenia");
            mensaje="El cambio de contraseña se realizo de forma exitosa"
                    + "<br/><b>ESTA CONTRASEÑA ES VÁLIDA PARA TODOS LOS SISTEMAS</b>"
                    +"<br/>Su contraseña tiene una validez de 3 meses";
            transaccionExistosa = true;
        }
        else{
            mensaje = "<span style='color:red'><b>LA CLAVE DE ACCESO YA FUE UTILIZADA ANTERIORMENTE, CAMBIO DE CONTRASEÑA NO REALIZADO.</b></span>";
            transaccionExistosa = false;
        }
        con.commit();
        
    }
    catch(Exception ex) 
    {
        mensaje="Ocurrio un error al momento de guardar el cambio de contraseña";
        ex.printStackTrace();
        con.rollback();
    }
    finally
    {
        con.close();
    }
%>
<html>
    
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
         <style type="text/css">
            .hint
            {
                font-weight: bold;
                display:none;
                position: absolute;
                border: 1px solid #eed3d7;
                color:#b94a48;
                width: 250px;
                text-align:left;
                z-index: 1000;
                font-size: 12px;
                background: #f2dede url(pointer.gif) no-repeat -10px 5px;
            }
            .tablaFiltroReporte
{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 12px;
                border:1px solid #bbbbbb;
            }
            .tablaFiltroReporte tr td
            {
                padding: 5px;
            }
            .tablaFiltroReporte thead tr td
            {
                color: white;
                border-bottom:1px solid #bbbbbb;
                text-align: center;
                font-weight: bold;
            }
            .tablaFiltroReporte tfoot tr td
            {
                text-align: center;
            }

        </style>
    </head>
    <body class="tdCenter">
        <center>
            <table class="tablaFiltroReporte" style="margin-top:20px" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td colspan='2' class="headerClassACliente">Cambio de Contraseña</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><img  src='<%=(transaccionExistosa ? "ok.gif":"notOk.gif")%>' style="width:50px"/></td>
                        <td>
                            <span class='outputText2'><%=(mensaje)%></span>
                        </td>
                    </tr>
                    <tr>
                        <td class="tdCenter" colspan='2'>
                            <a href="#" class="btn" onclick="window.location.href='<%=(urlLogin)%>'">Ir a Login</a>
                        </td>
                    </tr>
                </tbody>

            </table>
        </center>
    </body>
</html>

