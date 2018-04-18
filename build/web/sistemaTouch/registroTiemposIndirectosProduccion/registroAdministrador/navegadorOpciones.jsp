<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
            <style>
                span
                {
                    font-size:1.2em !important;
                }
                span:hover
                {
                    font-size:1.4em;
                }
            </style>
            <script>
                function registroTiemposIndirectosPersonal(codActividad)
                {
                    
                    window.location.href='registroTiempoPersonalIndirecto/registroTiempoIndirectos.jsf?codActividad='+codActividad+
                                         '&p='+(this.parent.codPersonalIndirecta)+
                                         '&cp='+(this.parent.codProgramaProdIndirecta)+
                                         '&ca='+(this.parent.codAreaEmpresaIndirecta)+
                                         '&data='+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body>
            
            <form>
                <section class="main" style="margin-top:1em;width:100%;">
                     <div class="large-6 medium-9 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Opciones</label>
                                   
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                            <div class="row" >
                                    <div class="large-12 medium-12 small-12 columns large-centered medium-centered small-centered">
                                         <div class='row' align='center' >
                                                <div class='divOptionGreen' onclick="window.location.href='navegadorCalificacionPersonal.jsf?data='+(new Date()).getTime().toString();" >
                                                    <span class='textHeaderClass'>Calificacion de personal</span>
                                                </div>
                                                <div class='divOptionGreen' onclick="window.location.href='navegadorAsigancionTareas.jsf?data='+(new Date()).getTime().toString()+'&ca='+window.parent.codAreaEmpresaIndirecta.toString()" >
                                                    <span class='textHeaderClass'>Asignación de Tareas</span>
                                                </div>
                                                <div class='divOptionGreen' onclick="window.location.href='navegadorActividadesIndirectas.jsf?data='+(new Date()).getTime().toString()+'&ca='+window.parent.codAreaEmpresaIndirecta.toString()">
                                                    <span class='textHeaderClass'>Revisión de Tiempos</span>
                                                </div>
                                        </div>
                                    </div>
                            </div>
                         </div>
                     </div>
                
                </section>
               
            </form>

        </body>
    </html>
</f:view>


