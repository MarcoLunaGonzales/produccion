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
                <rich:dataTable  value="#{ManagedComponentesProducto.resultado}"
                                 width="100%"  var="data" style="width:50%"
                                 onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                 onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                 id="resultadoBuscarProducto" headerClass="headerClassACliente">
                    <f:facet name="header">
                        <rich:columnGroup>
                            <rich:column>
                                <h:outputText value="Nombre"  />
                            </rich:column>
                        </rich:columnGroup>
                    </f:facet>
                    
                    
                    <rich:column >
                        <a4j:commandLink  onclick="document.getElementById('form1:panelBuscar').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';"
                                          actionListener="#{ManagedComponentesProducto.cogerCodigo}"   reRender="detalle">
                            <h:outputText value="#{data.nombre_accion_terapeutica} "  />
                            
                        </a4j:commandLink>
                    </rich:column>
                </rich:dataTable>
                
            </rich:panel>
            
            <!--buscar producto-->



            <div align="center">
                <h:outputText value="Editar Estado Producto Semiterminado" styleClass="outputText2" style="font-weight:bold;font-size:14;" />
                <rich:panel headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos de Producto Semiterminado" />
                            </f:facet>
                            <h:panelGrid columns="6" styleClass="outputText2">
                                <h:outputText value="Producto Semiterminado:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}"  />
                                <h:outputText value="Forma Farmaceutica:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.forma.nombreForma}"  />
                                <h:outputText value="Via Administracion:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                                <h:outputText value="Volumen Envase Primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.cantidadVolumen}"  />
                                <h:outputText value="Tolerancia Volumen a fabricar:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.toleranciaVolumenfabricar}"  />
                                <h:outputText value="Concentracion Envase Primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.concentracionEnvasePrimario}"  />
                                <h:outputText value="Peso envase primario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.pesoEnvasePrimario}"  />
                                <h:outputText value="Color Presentacion Primaria:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.coloresPresentacion.nombreColor}"  />
                                <h:outputText value="Sabor:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.saboresProductos.nombreSabor}"  />
                                <h:outputText value="Area Fabricacion:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.areasEmpresa.nombreAreaEmpresa}"  />
                                <h:outputText value="Nombre Generico:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.nombreGenerico}"  />
                                <h:outputText value="Reg. Sanitario:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.regSanitario}"  />
                                <h:outputText value="Fecha Vencimiento R.S.:"  style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.fechaVencimientoRS}">
                                    <f:convertDateTime pattern="dd/MM/yyyy" />
                                </h:outputText>
                                <h:outputText value="Vida Util:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.vidaUtil}"  />
                                <h:outputText value="Estado:" style="font-weight:bold" />
                                <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.nombreEstadoCompProd}"  />


                            </h:panelGrid>
                        </rich:panel>
                <h:panelGrid columns="4" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc">
                    <f:facet name="header" >
                        <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                    </f:facet>
                    
                    <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.codEstadoCompProd}" id="estado" >
                        <f:selectItems value="#{ManagedComponentesProducto.estadosCompProdList}"  />
                    </h:selectOneMenu>
                </h:panelGrid>
                <%--rich:panel  style="width:70%;border:1px solid #cccccc"  styleClass="panelgrid" headerClass="headerClassACliente" >
                    <f:facet name="header">
                        <h:outputText value="Acciones Terapeúticas" styleClass="outputText2" />
                    </f:facet>
                    
                    <h:panelGroup style="tex-align:left">
                        <a4j:commandLink action="#{ManagedComponentesProducto.mas}" reRender="detalle" accesskey="q" >
                            <h:graphicImage url="../img/mas.png" alt="mas"  style="border:0px solid red;"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedComponentesProducto.menos}" reRender="detalle" accesskey="w" >
                            <h:graphicImage url="../img/menos.png"  alt="menos"  style="border:0px solid red;"/>
                        </a4j:commandLink>
                    </h:panelGroup>
                    <h:panelGrid columns="1" width="100%">
                        <rich:dataTable value="#{ManagedComponentesProducto.detalleList}" var="data" id="detalle" width="100%"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                        headerClass="headerClassACliente"
                                        columnClasses="tituloCampo">
                            
                            <f:facet name="header">
                                <rich:columnGroup >
                                    <rich:column>
                                        <h:outputText value="Buscar" styleClass="tituloCampo" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Acción Terapeútica" styleClass="tituloCampo" />
                                    </rich:column>
                                    
                                    
                                </rich:columnGroup>
                            </f:facet>
                            <h:column>
                                <a4j:commandLink data="#{data.codTemp}"
                                                 onclick="document.getElementById('form1:panelBuscar').style.visibility='visible';document.getElementById('panelsuper').style.visibility='visible';" actionListener="#{ManagedComponentesProducto.cogerId}" accesskey="b">
                                    <h:graphicImage url="../img/lupa.png"  style="border:0px solid red;" />
                                </a4j:commandLink>
                            </h:column>
                            
                            <h:column>
                                <h:outputText value="#{data.accionesTerapeuticas.nombreAccionTerapeutica} " styleClass="tituloCampo" />
                            </h:column>
                        </rich:dataTable>
                    </h:panelGrid>
                </rich:panel--%>
                <br>
                <h:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProducto.guardarEstadoComponentesProd_action}" onclick="return validar('form1:detalle');" />
                <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedComponentesProducto.Cancelar}"/>
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



