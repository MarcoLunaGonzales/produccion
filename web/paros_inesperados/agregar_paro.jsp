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
               
                   var nombre=document.getElementById('form1:nombre');
                   var alto=document.getElementById('form1:alto');
                   var largo=document.getElementById('form1:largo');
                   var ancho=document.getElementById('form1:ancho');
                   var peso=document.getElementById('form1:peso');
                   var obs=document.getElementById('form1:obs');
                
                   if(nombre.value==''){
                     alert('El Campo Cartón Corrugado esta vacío.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensión Alto esta vacío.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensión Largo esta vacío.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensión Ancho esta vacío.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vacío.');
                     peso.focus();
                     return false;
                   }
                   if(obs.value==''){
                     alert('El Campo Descripción esta vacío.');
                     obs.focus();
                     return false;
                   }
                                   
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >
                <h:outputText value="#{ManagedParosInesperadosProd.codigoParosInesperados}" styleClass="outputText2" />
                <div align="center">
                    <br>
                    <h:outputText value="Registrar Paro Inesperado" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                        </f:facet>
                        <h:outputText value="Paro Inesperado" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedParosInesperadosProd.parosInesperadosProdbean.nombreParo}" onkeypress="valMAY();" id="nombre" /> 
                        
                        <h:outputText value="Descripción" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedParosInesperadosProd.parosInesperadosProdbean.obsParo}" id="obs"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />                                                
                        <h:outputText  styleClass="outputText2" value="::"/>                                
                        <h:inputText  styleClass="inputText" size="50" disabled="true" value="A C T I V O"/>                                
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedParosInesperadosProd.guardarParosInesperados}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedParosInesperadosProd.Cancelar}"/>
                </div>
                
            </h:form>
        </body>
    </html>
    
</f:view>

