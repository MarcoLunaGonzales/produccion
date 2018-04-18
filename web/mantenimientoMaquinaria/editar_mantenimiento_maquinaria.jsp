<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script src="../js/general.js"></script>
            <script>
              function validar(){

                    var codMaquina=document.getElementById('form1:codMaquina').value ;
                    var codFrecuenciaMantenimiento=document.getElementById('form1:codFrecuenciaMantenimiento').value ;
                    if(codMaquina=='-1'){
                        alert('Por favor Seleccione una maquina');
                        return false;
                    }
                    if(codFrecuenciaMantenimiento=='-1'){
                        alert('Por favor Seleccione una frecuencia de mantenimiento');
                        return false;
                    }
                    return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >
                
                <div align="center">
                    <h:outputText styleClass="outputTextTitulo"  value="Editar Mantenimiento Maquina" />
                    <br><br>
                        
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>
                        

                        <h:outputText styleClass="outputText2" value="Programa Produccion"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMantenimientoMaquina.mantenimientoMaquina.programaProduccionPeriodo.codProgramaProduccion}" >
                            <f:selectItems value="#{ManagedMantenimientoMaquina.programaProduccionList}"  />
                        </h:selectOneMenu>

                         <h:outputText styleClass="outputText2" value="Tipo Mantenimiento "/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMantenimientoMaquina.mantenimientoMaquina.tiposMantenimiento.codTipoMantenimiento}" >
                            <f:selectItems value="#{ManagedMantenimientoMaquina.tipoMantenimientoList}"  />
                        </h:selectOneMenu>

                        <h:outputText styleClass="outputText2"  value="Maquinaria " />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMantenimientoMaquina.mantenimientoMaquina.maquinaria.codMaquina}"  id="codMaquina">
                            <f:selectItems value="#{ManagedMantenimientoMaquina.maquinariaList}"  />
                            <a4j:support event="onchange" action="#{ManagedMantenimientoMaquina.maquinaria_change}" reRender="codFrecuenciaMantenimiento" />
                        </h:selectOneMenu>

                        <h:outputText styleClass="outputText2" value="Frecuencia Mantenimiento"/>
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedMantenimientoMaquina.mantenimientoMaquina.frecuenciasMantenimientoMaquina.codFrecuencia}" id="codFrecuenciaMantenimiento" >
                            <f:selectItems value="#{ManagedMantenimientoMaquina.frecuenciaMantenimientoMaquinaList}"  />
                        </h:selectOneMenu>
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedMantenimientoMaquina.aceptarEditarMantenimientoMaquina_action}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedMantenimientoMaquina.cancelarEditarMantenimientoMaquina_action }"/>
                    
                </div>
                
                
            </h:form>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>

