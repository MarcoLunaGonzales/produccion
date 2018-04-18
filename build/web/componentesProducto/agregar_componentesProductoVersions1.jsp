
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
                    /*    if(productosFormasFar.value==0){
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
                   
                   
                    if(document.getElementById('form1:columnStyle').innerHTML=='2'){
                        if(confirm('Para este Nombre Comercial ya existe un Producto Semiterminado. Si usted desea registrar un Producto Compuesto haga click en Aceptar.'))
                            document.getElementById('form1:codcompuestoprod').value='2';
                        else
                            document.getElementById('form1:codcompuestoprod').value='1';
                    }                   
                   
                    
                    
                   
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
                    var saboresProducto=document.getElementById('form1:saboresProducto');
                    //alert(saboresProducto.value);
                    var saboresProducto1=saboresProducto.options[saboresProducto.selectedIndex].text;
                    //alert(cantidadPeso.value);
                    var nombreProductoSemiterminado=document.getElementById('form1:nombreProductoSemiterminado');
                    
                    nombreProductoSemiterminado.value=nombreProductoSem+" "+nombreProductoSem1+" "+saboresProducto1;//" "+cantidadPeso.value
                }
            </script>
        </head>
        <body onload="carga();visibilityPanel();">

            <a4j:form id="form1"  >
                <div style="text-align:center">
                    <h:outputText value="#{ManagedComponentesProducto.cargarNuevoProductoSemiterminadoVersion}"/>


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


                    <h:outputText value="#{ManagedComponentesProducto.codigoProductosVenta}" styleClass="outputText2" />
                    <div align="center">

                        <h:outputText value="Registrar Producto Semiterminado" styleClass="outputText2" style="font-weight:bold;font-size:14;" />


                        <h:panelGrid columns="4" styleClass="panelgrid" headerClass="headerClassACliente" style="width:70%;border:1px solid #cccccc;margin-top:9px">
                            <f:facet name="header" >
                                <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                            </f:facet>

                            <h:outputText value="Nombre Comercial" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.producto.codProducto}" id="producto"  valueChangeListener="#{ManagedComponentesProducto.obtenerRegistrado}"  >
                                <f:selectItems value="#{ManagedComponentesProducto.productosList}" id="selectProducto" />
                                <a4j:support event="onchange"   reRender="columnStyle"  oncomplete="formarNombre();" />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Forma Farmaceútica" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.forma.codForma}" id="productosFormasFar" onchange="formarNombre();">
                                <f:selectItems value="#{ManagedComponentesProducto.productosFormasFarList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>
                            <h:outputText value="Via Administración" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.viasAdministracionProducto.codViaAdministracionProducto}" >
                                <f:selectItems value="#{ManagedComponentesProducto.viasAdministracionSelectList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <%--h:outputText value="Envase Primario " styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.envasesPrimarios.codEnvasePrim}" id="envasePrimario">
                                <f:selectItems value="#{ManagedComponentesProducto.envasesPrimariosList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/--%>

                            <%--h:outputText value="Volúmen/Concentración" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:inputText styleClass="inputText" size="35" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.volumenPesoEnvasePrim}"  id="volumenPesoPresentacion" onchange="formarNombre();"/>
                            <h:outputText  styleClass="outputText2"  value=""/--%>

                            <h:outputText value="Volúmen Envase Primario" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:panelGroup>
                                <h:inputText onkeypress="valNum();" styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.cantidadVolumen}"/>
                                <h:selectOneMenu style='margin-left:8px;' value="#{ManagedComponentesProducto.componentesProdbean.unidadMedidaVolumen.codUnidadMedida}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedComponentesProducto.unidadesMedidadSelectList}"/>
                                </h:selectOneMenu>

                            </h:panelGroup>
                            <h:outputText  styleClass="outputText2"  value=""/>
                            <h:outputText value="Tolerancia Volumen a fabricar" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:inputText onkeypress="valNum();" styleClass="inputText" size="35"  value="#{ManagedComponentesProducto.componentesProdbean.toleranciaVolumenfabricar}"  />
                            <%--h:inputText styleClass="inputText" size="35" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.volumenEnvasePrimario}"  id="volumenEnvasePrimario" /--%>
                            <h:outputText  styleClass="outputText2"  value=""/>
                            <h:outputText value="Peso Envase Primario" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:inputText styleClass="inputText" size="35" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.pesoEnvasePrimario}"  id="pesoEnvasePrimario" />
                            <h:outputText  styleClass="outputText2"  value=""/>
                            
                            <h:outputText value="Color Presentación Primaria" styleClass="outputText2"  />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.coloresPresentacion.codColor}" id="coloresPresentacion">
                                <f:selectItems value="#{ManagedComponentesProducto.coloresProductoList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Sabor" styleClass="outputText2"  />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.saboresProductos.codSabor}" id="saboresProducto" onchange="formarNombre();">
                                <f:selectItems value="#{ManagedComponentesProducto.saboresProductoList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Área de Fabricación" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.areasEmpresa.codAreaEmpresa}" id="areaFabricacion">
                                <f:selectItems value="#{ManagedComponentesProducto.areasEmpresaList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Nombre Producto Semiterminado" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" onkeypress="valMAY();" value="#{ManagedComponentesProducto.componentesProdbean.nombreProdSemiterminado}"  id="nombreProductoSemiterminado" />
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Nombre Genérico" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:inputText styleClass="inputText" size="50" value="#{ManagedComponentesProducto.componentesProdbean.nombreGenerico}"  id="nombreGenerico" />
                            <h:outputText  styleClass="outputText2"  value=""/>
                            <h:outputText value="Estado" styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:outputText  styleClass="outputText2"  value="Activo"/>
                            <%--h:inputText styleClass="inputText" size="20"  value="ACTIVO" disabled="true"  id="estado" /--%>
                            <h:outputText  styleClass="outputText2"  value=""/>
                            <h:outputText value="Tipo Producción" styleClass="outputText2"/>
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.codTipoProduccion}" styleClass="inputText">
                                <f:selectItems value="#{ManagedComponentesProducto.tiposProduccionList}"/>
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

                        <h:outputText value="#{ManagedComponentesProducto.componentesProdbean.columnStyle}"  id="columnStyle"  style="visibility:hidden"/>
                        <h:inputHidden value="#{ManagedComponentesProducto.componentesProdbean.codcompuestoprod}"  id="codcompuestoprod"  />
                        <h:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProducto.guardarComponentesProdVersion1}" onclick="return validar('form1:detalle');"/>
                        <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedComponentesProducto.cancelarEdicion_action}"/>
                    </div>

                        <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden" >
                        </h:panelGroup>
                       
                </a4j:form>
            </div>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        </body>
    </html>

</f:view>

