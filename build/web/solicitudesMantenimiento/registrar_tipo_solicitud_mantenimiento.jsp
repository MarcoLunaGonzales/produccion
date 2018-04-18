package solicitudesMantenimiento;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>

        </head>
        <body >
            <h:form id="form1"  >

                <div align="center">
                    <br>
                    <h3 align="center">Registrar Tipo Orden de Trabajo</h3>
                    <br>
                    <h:outputText value="#{ManagedTipoSolicitudMantenimiento.init}"/>
                    <h:panelGrid columns="3" width="65%" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>


                        <h:outputText styleClass="outputText2" value="Tipo de Solicitud"/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedTipoSolicitudMantenimiento.codTipoSolMantenimiento}">
                            <f:selectItems value="#{ManagedTipoSolicitudMantenimiento.tiposSolicitudMantenimientoList}"/>
                        </h:selectOneMenu>

                        <h:outputText styleClass="outputText2" value="Afecta a Produccion"/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedTipoSolicitudMantenimiento.afectaProduccion}">
                            <f:selectItem itemLabel="SI" itemValue="1" />
                            <f:selectItem itemLabel="NO" itemValue="0" />
                        </h:selectOneMenu>

                    </h:panelGrid>

                    <br>

                    <br>

                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedTipoSolicitudMantenimiento.guardarSolicitudMantenimiento}"   onclick="return validarFecha();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedTipoSolicitudMantenimiento.cancelar}"/>

                </div>


            </h:form>
        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>

    </html>

</f:view>

