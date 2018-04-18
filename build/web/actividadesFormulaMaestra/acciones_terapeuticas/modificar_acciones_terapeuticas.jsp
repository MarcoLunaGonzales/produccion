<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script type="text/javascript" src="../js/general.js"></script>
            <script>
                function validar(){
                   var nombreCadenaCliente=document.getElementById('form1:nombreCadenaCliente');
                   var nitCliente=document.getElementById('form1:nitCliente');
                   if(nombreCadenaCliente.value==''){
                     alert('El Campo Acción Terapeútica esta vacío.');
                     nombreCadenaCliente.focus();
                     return false;
                   }
                   if(nitCliente.value==''){
                     alert('El Campo NIT esta vacío.');
                     nitCliente.focus();
                     return false;
                   }                   
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >                
                <div align="center">
                    <br>
                    <h:outputText value="Editar Acción Terapeútica" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="1"   width="70%" >
                        <rich:panel style="text-align:center;"headerClass="headerClassACliente" >
                            <f:facet name="header" >
                                <h:outputText value="Introduzca datos"  /> 
                            </f:facet>
                            <h:panelGrid columns="3" >
                                <h:outputText value="Acción Terapeútica" styleClass="outputText2" />
                                <h:outputText  styleClass="outputText2"  value="::"/>  
                                <h:inputText styleClass="inputText" size="50" value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasbean.nombreAccionTerapeutica}" onkeypress="valMAY();" id="nombreCadenaCliente" /> 
                                
                                <h:outputText value="Descripción" styleClass="outputText2"  />
                                <h:outputText  styleClass="outputText2"  value="::"/>  
                                <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasbean.obsAccionTerapeutica}" id="obsdistrito"   />
                                
                                <h:outputText value="Estado" styleClass="outputText2"   />                                                
                                <h:outputText  styleClass="outputText2" value="::"/>                                
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedAccionesTerapeuticas.accionesTerapeuticasbean.estadoReferencial.codEstadoRegistro}" >
                                    <f:selectItems value="#{ManagedAccionesTerapeuticas.estadoRegistro}"  />
                                </h:selectOneMenu>          
                            </h:panelGrid>
                        </rich:panel>                                                        
                        
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedAccionesTerapeuticas.modificarAccionesTerapeuticas}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedAccionesTerapeuticas.Cancelar}"/>
                </div>                                
            </h:form>
        </body>
    </html>
    
</f:view>

