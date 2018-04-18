<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script>
            <script>
                function validarFormulario(){

                    var nombre_envasesecund=document.getElementById('formulario:nombre');
                    if(nombre_envasesecund.value==''){
                        alert('El Campo Envase Secundario esta vacío.');
                        nombre_envasesecund.focus();
                        return false;
                    }

                    if(document.getElementById('formulario:fechaInicio').value==''){
                        alert('La fecha inicial esta vacia.');
                        document.getElementById('formulario:fechaInicio').focus();
                        return false;
                    }
                    if(document.getElementById('formulario:fechaFin').value==''){
                        alert('La fecha final esta vacia.');
                        document.getElementById('formulario:fechaFin').focus();
                        return false;
                    }
                    var horasTrabajo=document.getElementById('formulario:horasTrabajo');
                    alert(horasTrabajo);
                    if(horasTrabajo.value==''){
                        alert('La hora trabajo esta vacia.');
                        document.getElementById('formulario:horasTrabajo').focus();
                        return false;
                    }

                    return true;
                }
                function seleccionarAsignado(valorCheck)
                {
                    if(valorCheck=="interno"){
                        document.getElementById('formulario:selectPersonal').disabled= false;
                        document.getElementById('formulario:selectProovedor').disabled= true;
                    }else{
                        document.getElementById('formulario:selectPersonal').disabled= true;
                        document.getElementById('formulario:selectProovedor').disabled=false;
                    }
                }
            </script>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </head>
        <body>
            <br><br>
            <h:form id="formulario"  >
                <div align="center"><br>
                    <h:outputText value="Asignar Tiempo Real de Trabajo" styleClass="tituloCabezera1"    />

                    <br> <br>
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos " styleClass="outputText2"   />
                        </f:facet>


                        <%--datos para la insercion de datos --%>
                        <h:outputText  value="Fecha Inicio Estimado" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText  value="#{ManagedRegistroSolicitudTrabajos.asignarTiempoRealItemTrabajo.fechaInicio}" styleClass="outputText2"  />

                        <h:outputText  value="Fecha Inicio Estimado" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:outputText  value="#{ManagedRegistroSolicitudTrabajos.asignarTiempoRealItemTrabajo.fechaFin}" styleClass="outputText2"  />

                        <h:outputText  value="Fecha Inicio Estimado" styleClass="outputText2"/>
                        <h:outputText styleClass="outputText2" value="::"/>
                        <h:outputText  value="#{ManagedRegistroSolicitudTrabajos.asignarTiempoRealItemTrabajo.horasTrabajo}" styleClass="outputText2"/>


                        <h:outputText  value="Fecha Inicio" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />

                        <rich:calendar  datePattern="dd/MM/yyyy" value="#{ManagedRegistroSolicitudTrabajos.fechaInicio}" id="fechaInicio" enableManualInput="false"  />

                        <h:outputText  value="Fecha Final" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />

                        <rich:calendar   datePattern="dd/MM/yyyy" value="#{ManagedRegistroSolicitudTrabajos.fechaFin}" id="fechaFin" enableManualInput="false" />

                        <h:outputText value="Horas de Trabajo" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedRegistroSolicitudTrabajos.asignarTiempoRealItemTrabajo.horasTrabajoReal}" id="horasTrabajoReal"/>
                        
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedRegistroSolicitudTrabajos.guardarAsignacionTiempoRealTrabajo_action}" onclick="return validarFormulario();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedRegistroSolicitudTrabajos.cancelarAsignacionTiempoReal_action}" />
                </div>
            </h:form>
        </body>
    </html>

</f:view>

