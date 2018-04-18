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
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <script type="text/javascript" src='../reponse/js/scripts.js' ></script>
            <script type="text/javascript" src='../reponse/js/websql.js' ></script>
          
        </head>
        <script>
            sqlConnection.crearTabla();
        </script>
          <%
                String mensaje=(String)session.getAttribute("mensaje");
                mensaje=mensaje==null?"":mensaje;
                session.setAttribute("codAreaEmpresa",null);
                session.setAttribute("mensaje", null);
        %>
        <body ><div style="margin-top:4em;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load3.GIF"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
            <form method="post" action="verificar.jsf" name="form_login">
                
                <section class="main">
                         <div class="row"  style="margin-top:10px" >
                                <div class="large-6 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Tiempos Almacen</label>
                                                </div>
                                            </div>
                                            <div class="row">
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                    <div class="row " style="margin-top:4%" >
                                                            <div class="large-3 medium-3 small-10 columns">
                                                            <label class="inline">USUARIO</label>
                                                            </div>
                                                            <div class="large-1 medium-1 small-2 columns">
                                                            <label class="inline">:</label>
                                                            </div>
                                                            <div class="large-8 medium-8 small-12 columns">
                                                                <input style="margin-bottom:0.5em" placeholder="Usuario" type="text" id="nombreUsuario" name="nombreUsuario"/>
                                                            </div>
                                                    </div>
                                                    
                                                    <div class="row">
                                                        <div class="large-3 medium-3 small-10 columns">
                                                            <label class="inline">CONTRASEÑA</label>
                                                            </div>
                                                            <div class="large-1 medium-1 small-2 columns">
                                                            <label class="inline">:</label>
                                                            </div>
                                                        <div class="large-8 medium-8 small-12 columns">
                                                            <input style="margin-bottom:0.5em" placeholder="Contraseña" type="password" value="" id="contranaUsuario" name="contranaUsuario" >
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
                       
                </section>
                
            </form>
            
         <div  id="formsuper"  class="formSuper" />

        </body>
    </html>
</f:view>


