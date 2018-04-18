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
                function validar(){
                   var nombreep=document.getElementById('form1:nombreep');
                   if(nombreep.value==''){
                     alert('El Campo Envase Primario esta vacío.');
                     nombreep.focus();
                     return false;
                   }
                   return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1"  >                
                <div align="center">
                    <br>
                    <h:outputText value="Editar Envase Primario" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"   />
                        </f:facet>
                        <h:outputText value="Envase Primario" styleClass="outputText2"/>   
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" onkeypress="valMAY();"  size="52"  value="#{ManagedEnvasesPrimarios.envasePrimario.nombreEnvasePrim}" id="nombreep"  />
                        
                        <h:outputText value="Observaciones" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" rows="3" cols="50" value="#{ManagedEnvasesPrimarios.envasePrimario.obsEnvasePrim}"   />
                        
                        <h:outputText value="Estado de Registro" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEnvasesPrimarios.envasePrimario.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedEnvasesPrimarios.estadoRegistro}"  />
                        </h:selectOneMenu>
                        
                    </h:panelGrid>
                    
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedEnvasesPrimarios.editEnvasesPrimarios}" onclick="return validar();"  />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="navegadorenvasesprimarios" />                                        
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

