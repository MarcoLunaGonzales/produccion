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
                   var nombretipomercaderia=document.getElementById('form1:nombre');
                   if(nombretipomercaderia.value==''){
                     alert('El Campo Tipo de Mercadería está vacio.');
                     nombretipomercaderia.focus();
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
                    <h:outputText value="Editar Tipo de Mercadería" styleClass="tituloCabezera1" />     
                    <br><br>
                    <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2"    />
                        </f:facet>                                
                        <h:outputText value="Tipo de Mercadería" styleClass="outputText2"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" id="nombre" size="40"  onkeypress="valMAY();" value="#{ManagedTiposmercaderia.tiposMercaderia.nombreTipoMercaderia}" style='text-transform:uppercase;'/>
                        
                        <h:outputText value="Descripción" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" rows="3" cols="38" value="#{ManagedTiposmercaderia.tiposMercaderia.obsTipoMercaderia}" id="obsTipoMercaderia"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedTiposmercaderia.tiposMercaderia.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedTiposmercaderia.estadoRegistro}"  />
                        </h:selectOneMenu>
                    </h:panelGrid>
                    <br>           
                    <h:commandButton value="Guardar" styleClass="commandButton"  action="#{ManagedTiposmercaderia.editTipoMercaderia}" onclick="return validar()"/>
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedTiposmercaderia.actionCancelar}" />
                    
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

