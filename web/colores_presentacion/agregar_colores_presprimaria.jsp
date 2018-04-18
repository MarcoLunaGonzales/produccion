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
                     alert('El Campo Color Presentación esta vacío.');
                     nombreCadenaCliente.focus();
                     return false;
                   }
                                   
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >
                <h:outputText value="#{ManagedColoresPresentacion.codigoColores}" styleClass="outputText2" />
                <div align="center">
                    <br>
                    <h:outputText value="Registrar Color Presentación" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                        </f:facet>
                        
                        <h:outputText value="Color Presentación" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedColoresPresentacion.colorPresentacionbean.nombreColor}" onkeypress="valMAY();" id="nombreCadenaCliente" /> 
                        
                        <h:outputText value="Descripción" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedColoresPresentacion.colorPresentacionbean.obsColor}" id="obsdistrito"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />                                                
                        <h:outputText  styleClass="outputText2" value="::"/>                                
                        <h:inputText  styleClass="inputText" size="50" disabled="true" value="A C T I V O"/>                                
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedColoresPresentacion.guardarColoresPresentacion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedColoresPresentacion.Cancelar}"/>
                </div>
                
            </h:form>
        </body>
    </html>
    
</f:view>

