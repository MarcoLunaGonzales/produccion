

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.web.ManagedAccesoSistema" %>
<%@page import="com.cofar.util.*"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <%--link rel="STYLESHEET" type="text/css" href="AtlasWeb.css" /--%>
            <link rel="STYLESHEET" type="text/css" href="reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="reponse/css/AtlasWeb.css" />
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function validar(){                
                    return true;
                    
                }
                function checkKey(key)
                {
                        var unicode
                        if (key.charCode)
                        {
                            unicode=key.charCode;
                        }
                        else
                        {
                            unicode=key.keyCode;
                        }
                        if (unicode == 13)
                        {
                          //  document.getElementById('form1:aceptar').click();
                        }

                }
                
            </script>
        </head>
          <%String codAreaEmpresa=(request.getParameter("codArea")!=null?request.getParameter("codArea"):"81");
          System.out.println("codAres"+codAreaEmpresa);
                String mensaje=(String)session.getAttribute("mensaje");
                mensaje=mensaje==null?"":mensaje;
                session.setAttribute("codAreaEmpresa",null);
                session.setAttribute("mensaje", null);
        %>
        <body>
            <form method="post" action="verificar.jsf" name="form_login">
                
                <section class="main">-
                         <div class="row"  style="margin-top:10px" >
                                <div class="large-6 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Atlas</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                    <div class="row " style="margin-top:4%" >
                                                            <div class="large-3 medium-3 small-10 columns">
                                                            <label class="inline">Usuario</label>
                                                            </div>
                                                            <div class="large-1 medium-1 small-2 columns">
                                                            <label class="inline">:</label>
                                                            </div>
                                                            <div class="large-8 medium-8 small-12 columns">
                                                                 <input type="text" id="nombreUsuario" autocomplete="off" list="languages" name="nombreUsuario" value="" placeHolder="USUARIO" >
                                                                    <datalist id="languages">
                                                                    <%
                                                                    Connection con=null;
                                                                    try
                                                                    {
                                                                        con=Util.openConnection(con);
                                                                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                                        StringBuilder consulta=new StringBuilder("select u.NOMBRE_USUARIO");
                                                                                                consulta.append(" from USUARIOS_MODULOS u ");
                                                                                                        consulta.append(" inner join PERSONAL_AREA_PRODUCCION pap on pap.COD_PERSONAL=u.COD_PERSONAL");
                                                                                                consulta.append(" where u.COD_MODULO=10");
                                                                                                        consulta.append(" and pap.COD_AREA_EMPRESA in (").append(codAreaEmpresa).append(")");
                                                                                                consulta.append(" order by u.NOMBRE_USUARIO");
                                                                        System.out.println("consulta usuarios "+consulta.toString());
                                                                        ResultSet res=st.executeQuery(consulta.toString());
                                                                        while(res.next())
                                                                        {
                                                                            out.println("<option value='"+res.getString("NOMBRE_USUARIO")+"'/>");
                                                                        }
                                                                        st.close();
                                                                        con.close();
                                                                    }
                                                                    catch(SQLException ex)
                                                                    {
                                                                        ex.printStackTrace();
                                                                    }
                                                                    finally
                                                                    {
                                                                        con.close();
                                                                    }
                                                                    %>
                                                                </datalist>
                                                                
                                                            </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-3 medium-3 small-10 columns">
                                                            <label class="inline">Contraseña</label>
                                                            </div>
                                                            <div class="large-1 medium-1 small-2 columns">
                                                            <label class="inline">:</label>
                                                            </div>
                                                        <div class="large-8 medium-8 small-12 columns">
                                                            <input type="password" value="" id="contranaUsuario" name="contranaUsuario" placeHolder="CONTRASEÑA" onkeypress="checkKey(event);">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-4 large-centered columns">
                                                        <input type="submit" name="aceptar" value="Aceptar" class="small-12 medium-12 large-12 columns button succes radius buttonAction" style=" line-height:20pt;">
                                                        
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="large-12 large-centered columns">
                                                            <center>
                                                              
                                                                <span style="color:red;font-weight:bold;"><%=mensaje%></span>
                                                                
                                                            </center>
                                                        </div>
                                                    </div>
                                             </div>
                                             </div>
                                         </div>
                            </div>
                       <input type="hidden" id="codAreaEmpresaLogin" name="codAreaEmpresaLogin" value="<%=(codAreaEmpresa)%>">
                
                </section>
                
            </form>
         
        </body>
    </html>
</f:view>


