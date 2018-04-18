<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script>
                function validar(){
                   var compronenteProd=document.getElementById('form1:compronenteProd');                  
                   if(compronenteProd.value==''){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     compronenteProd.focus();
                     return false;
                   }                   
                   return true;
                }
            </script>
        </head>
        <body background="../img/fondo.jpg">
            <h:form id="form1"  >
                
                
                <div align="center">
                    <h:outputText styleClass="outputTextTitulo"  value="Registrar Parte de la  Máquina : #{ManagedPartesMaquinaria.nombreMaquinaria}" />                    
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca Datos" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>    
                        
                        <h:outputText styleClass="outputText2" value="Código - Area"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedPartesMaquinaria.codigo}"  disabled="true"  />
                        
                        <h:outputText styleClass="outputText2" value="Código Parte"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedPartesMaquinaria.partesMaquinariabean.codigo}" id="codigo"  />
                        
                        <h:outputText styleClass="outputText2" value="Parte"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedPartesMaquinaria.partesMaquinariabean.nombreParteMaquina}" id="maquina"  />
                        
                        <h:outputText value="Tipo de Maquinaria" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedPartesMaquinaria.partesMaquinariabean.tiposEquiposMaquinaria.codTipoEquipo}" >
                            <f:selectItems value="#{ManagedPartesMaquinaria.tiposEquiposList}"  />
                        </h:selectOneMenu>    
                        
                        <h:outputText value="Descripción" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedPartesMaquinaria.partesMaquinariabean.obsParteMaquina}" id="obs"   />
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedPartesMaquinaria.guardarPartesMaquina}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedPartesMaquinaria.cancelar}"/>
                    
                </div>
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
            </h:form>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>

