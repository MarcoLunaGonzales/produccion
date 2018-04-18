<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }
            </style>            
        </head>
        <body >
            
            
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSolicitudMantenimiento.cargarSeguimientoSolicitudMantenimiento}"  />
                    <br>
                    <h3 align="center">Seguimiento Órden de Trabajo Nro : <h:outputText value="#{ManagedSolicitudMantenimiento.codigo}"  /> </h3>
                    <br>
                        <rich:dataTable value="#{ManagedSolicitudMantenimiento.seguimientoSolicitudMantList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha Cambio Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaCambioEstadoSolicitud}"  />
                        </rich:column >
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.obsSolicitudMantenimiento}" />
                        </rich:column >
                        
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado Solicitud"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                        </rich:column >
     
                        
                    </rich:dataTable>
                    
                    <br>
                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedSolicitudMantenimiento.closeConnection}"  />
                
            </a4j:form>
            
        </body>
    </html>
    
</f:view>

