


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
            </script>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>            
        </head>
        <body>
            <br><br>
            <h:form id="formulario"  >
                <div align="center"><br>
                    <h:outputText value="Registrar Materiales de Solicitud de Mantenimiento" styleClass="tituloCabezera1"    />

                    <br> <br>
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos " styleClass="outputText2"   />
                        </f:facet>
                        <h:outputText  value="Material" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />

                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedRegistroSolicitudMateriales.adicionarItemMaterial.codMaterial}">
                            <f:selectItems value="#{ManagedRegistroSolicitudMateriales.materialesList}"/>
                        </h:selectOneMenu>

                        <h:outputText value="Descripción" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedRegistroSolicitudMateriales.adicionarItemMaterial.descripcion}"/>


                        <h:outputText  value="Fecha Final" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <rich:calendar   datePattern="dd/MM/yyyy" value="#{ManagedRegistroSolicitudTrabajos.fechaFin}" id="fechaFin" enableManualInput="false" />

                        <h:outputText  value="Cantidad" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />                        
                        <h:inputText styleClass="inputText" value="#{ManagedRegistroSolicitudMateriales.adicionarItemMaterial.cantidad}" id="cantidad"/>

                        <h:outputText value="Estado" styleClass="outputText2"/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" disabled="true" size="40" value="ACTIVO"/>
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedRegistroSolicitudMateriales.action_guardarMaterial}" onclick="return validarFormulario();" />                                        
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedRegistroSolicitudMateriales.cancelar_action}" />
                </div>
            </h:form>
        </body>
    </html>

</f:view>

