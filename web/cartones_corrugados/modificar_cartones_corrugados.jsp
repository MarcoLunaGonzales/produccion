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
                   
                
                   if(nombre.value==''){
                     alert('El Campo Cart�n Corrugado esta vac�o.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensi�n Alto esta vac�o.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensi�n Largo esta vac�o.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensi�n Ancho esta vac�o.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vac�o.');
                     peso.focus();
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
                    <h:outputText value="Editar Cart�n Corrugado" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"  />
                        </f:facet>
                        
                        <h:outputText value="Cart�n Corrugado" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.nombreCarton}" onkeypress="valMAY();" id="nombre" /> 
                        
                        <h:outputText value="Dimensi�n Alto" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.dimAlto}" onkeypress="valNum();" id="alto" /> 
                        
                        <h:outputText value="Dimensi�n Largo" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.dimLargo}" onkeypress="valNum();" id="largo" /> 
                        
                        <h:outputText value="Dimensi�n Ancho" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.dimAncho}" onkeypress="valNum();" id="ancho" /> 
                        
                        <h:outputText value="Peso Gramos" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.pesoGramos}" onkeypress="valNum();" id="peso" /> 
                        
                        <h:outputText value="Descripci�n" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.obsCarton}" id="obs"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />                                                
                        <h:outputText  styleClass="outputText2" value="::"/>                                
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedCartonesCorrugados.cartonesCorrugadosbean.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedCartonesCorrugados.estadoRegistro}"  />
                        </h:selectOneMenu>          
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedCartonesCorrugados.modificarCartonesCorrugados}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedCartonesCorrugados.Cancelar}"/>
                </div>                                
            </h:form>
        </body>
    </html>
    
</f:view>

