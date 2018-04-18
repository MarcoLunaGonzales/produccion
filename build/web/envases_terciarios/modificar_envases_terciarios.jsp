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
                   var nombre_envasesecund=document.getElementById('form1:nombre');
                   if(nombre_envasesecund.value==''){
                     alert('El Campo Envase Secundario esta vac�o.');
                     nombre_envasesecund.focus();
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
                    <h:outputText value="Editar Envase Terciario" styleClass="tituloCabezera1"    />
                    <br><br>
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2"    />
                        </f:facet>
                        <h:outputText  value="Envase Terciario" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" id="nombre" size="40"  onkeypress="valMAY();" value="#{ManagedEnvasesTerciarios.envasesTerciariosbean.nombreEnvaseTerciario}" style='text-transform:uppercase;'/>
                        
                        <h:outputText value="Descripci�n" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedEnvasesTerciarios.envasesTerciariosbean.obsEnvaseTerciario}"/>
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEnvasesTerciarios.envasesTerciariosbean.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedEnvasesTerciarios.estadoRegistro}"  />
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedEnvasesTerciarios.editEnvasesTerciarios}" onclick="return validar();"  />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedEnvasesTerciarios.Cancelar}" />
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

