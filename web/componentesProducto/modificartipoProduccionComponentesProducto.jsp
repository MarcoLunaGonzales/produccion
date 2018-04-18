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
                function validar(nametable){
                    
                    var producto=document.getElementById('form1:producto');
                    var productosFormasFar=document.getElementById('form1:productosFormasFar');
                    var envasePrimario=document.getElementById('form1:envasePrimario');
                    var areaFabricacion=document.getElementById('form1:areaFabricacion');
                   
                    if(producto.value==0){
                        alert("El campo Nombre Comercial está vacio.");
                        producto.focus();
                        return false;
                    }
                    /*   if(productosFormasFar.value==0){
                             alert("El campo Forma Farmaceútica está vacio.");
                             productosFormasFar.focus();
                             return false;
                           }
                           if(envasePrimario.value==0){
                             alert("El campo Envase Primario está vacio.");
                             envasePrimario.focus();
                             return false;
                           }
                           if(areaFabricacion.value==0)
                           {  alert("El campo Área de Fabricación está vacio.");
                              areaFabricacion.focus();
                              return false;
                           }*/
                    /* var elements=document.getElementById(nametable);
                           var rowsElement=elements.rows;
                                      
                           if(rowsElement.length==1){
                                alert("No existe ningún Principio Activo registrado.");
                                return false;
                           }
                           for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            var cel_0=cellsElement[1];
                            var cel_1=cellsElement[2];
                            var data1=cel_0.getElementsByTagName('SPAN')[0].innerHTML;
                            var data2=cel_1.getElementsByTagName('input')[0].value;
                                if(data1=='' || data1==' '){
                                    alert("El campo Principio Activo se encuentra vacío.");
                                    return false;
                                }
                                if(data2==''){
                                    alert("El campo Concentración se encuentra vacío.");
                                    return false;
                                }
                           }*/
                    return true;
                }
                  
                function visibilityPanel(){
                    document.getElementById('form1:panelBuscar').style.visibility='hidden';
                }
                function formarNombre(){
                       
                    var nombreProducto=document.getElementById('form1:producto');
                    var nombreProductoSem=nombreProducto.options[nombreProducto.selectedIndex].text;
                    var productosFormasFar=document.getElementById('form1:productosFormasFar');
                    var nombreProductoSem1=productosFormasFar.options[productosFormasFar.selectedIndex].text;
                    //var cantidadPeso=document.getElementById('form1:volumenPesoPresentacion');
                    //alert(cantidadPeso.value);
                    var nombreProductoSemiterminado=document.getElementById('form1:nombreProductoSemiterminado');
                    nombreProductoSemiterminado.value=nombreProductoSem+" "+nombreProductoSem1;//+" "+cantidadPeso.value;
                
                }
                                    </script>
</head>
<body onload="carga();visibilityPanel();">
    
    <a4j:form id="form1"  >
        <div style="text-align:center">
        
        <a4j:region id="regionUno">
            
            
            <rich:panel id="panelBuscar" styleClass="panelBuscar" headerClass="headerClassACliente"
                        style="top:100px;left:150px;"
            >
                <f:facet name="header">
                    <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelBuscar');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"closePanelBuscar();\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                                  escape="false" />
                </f:facet>
                
                
                <h:panelGrid columns="2" headerClass="headerClassACliente" width="50%">
                    <f:facet name="header">
                        <h:outputText value="Acción Terapeútica"  styleClass="tituloCampo"/>
                    </f:facet>
                    <h:inputText value="#{ManagedComponentesProducto.accionTerapeutica}" onkeypress="valMAY();"   styleClass="inputText"
                                 size="50" id="principioBuscar"  valueChangeListener="#{ManagedComponentesProducto.buscarAccionesTerapeuticas}">
                        <a4j:support  event="onkeyup"  reRender="resultadoBuscarProducto"  />
                    </h:inputText>
                    
                    
                </h:panelGrid>
            </rich:panel>
            <!--buscar producto-->
            <div align="center">
                <h:outputText value="Editar Producto Semiterminado" styleClass="tituloCabezera1"    />
                <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente" style="width:50%;border:1px solid #cccccc">
                    <f:facet name="header" >
                        <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                    </f:facet>
                    <h:outputText value="Nombre Producto Semiterminado" styleClass="outputText2" />
                    <h:outputText  styleClass="outputText2"  value="::"/>
                    <h:outputText styleClass="outputText2" value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}"/>

                    <h:outputText value="Produccion" styleClass="outputText2" />
                    <h:outputText  styleClass="outputText2"  value="::"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.codTipoProduccion}" id="codTipoProduccion" >
                        <f:selectItems value="#{ManagedComponentesProducto.tiposProduccionList}"  />
                    </h:selectOneMenu>

                    <h:outputText value="Estado" styleClass="outputText2" />
                    <h:outputText  styleClass="outputText2"  value="::"/>
                    <h:outputText  styleClass="outputText2"  value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.nombreEstadoCompProd}"/>
                    
                </h:panelGrid>
                <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedComponentesProducto.guardarEditarTipoProduccion_action}"  />
                <a4j:commandButton value="Cancelar"  styleClass="commandButton" onclick="location='navegador_componentesProducto.jsf'" />
            </div>
        </a4j:region>
    </a4j:form>
    </div>
    <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden" >
    </h:panelGroup>
    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



