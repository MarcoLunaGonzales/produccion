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
                   if(!(parseInt(document.getElementById('form1:cantidad').value)>0))
                       {
                           alert('La cantidad del Lote no puede ser menor o igual a cero');
                           return false;

                       }
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
                
                <h:outputText value="#{ManagedFormulaMaestra.codigoCliente}"  />
                <div align="center">
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Registrar Formula Maestra" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Producto"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.codCompprod}">
                            <f:selectItems value="#{ManagedFormulaMaestra.componentesProd}"/>
                        </h:selectOneMenu>
                        
                        <h:outputText  styleClass="outputText2" value="Cantidad del Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedFormulaMaestra.formulaMaestrabean.cantidadLote}" id="cantidad"  />
                        <h:outputText styleClass="outputText2" value="Tipo Producción"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedFormulaMaestra.formulaMaestrabean.componentesProd.tipoProduccion.codTipoProduccion}" disabled="true">
                            <f:selectItems value="#{ManagedFormulaMaestra.tiposProduccionList}"/>
                        </h:selectOneMenu>

                        <h:outputText value="Estado" styleClass="outputText2"   />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText  styleClass="inputText" disabled="true" value="ACTIVO"/>                            
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestra.guardarFormulaMaestra}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedFormulaMaestra.Cancelar}"/>
                    
                </div>
                
                <%@ include file="../WEB-INF/jspx/footer.jsp" %>
            </h:form>
        </body>
    </html>
    
</f:view>

