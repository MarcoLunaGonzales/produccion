<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
            </style>
            <script type="text/javascript">
            function nuevoAjax()
            {
                var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                }
                catch (e) {
                    try
                    {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch (E)
                    {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }
                return xmlhttp;
            }
            function verModificacionProductoSemiterminado(codCompProd,codVersion)
            {
                
                var contain;
                contain=document.getElementById("div_productoModificado");
                
                ajax=nuevoAjax();
                ajax.open("GET","ajaxProductoModificado.jsf?codCompProd="+codCompProd+"&codVersion="+codVersion+"&cod="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        contain.innerHTML=ajax.responseText;
                        mostrarModal();
                    }
                }
                ajax.send(null);
            }
     function mostrarModal(){
                document.getElementById('divDetalle').style.marginTop=(document.documentElement.scrollTop+30);
                document.getElementById('divDetalle').style.visibility='visible';
                document.getElementById('formSuper').style.visibility='visible';
                var a = document.getElementById('formSuper').style;
                a.height=document.body.offsetHeight;
                return false;
            }
    function ocultarModal(){
        document.getElementById('divDetalle').style.visibility='hidden';
        document.getElementById('formSuper').style.visibility='hidden';
        return false;
    }
</script>
        </head>
        
        <body onload="carga()">
            <div  id="divDetalle" style="
              background-color: #FFFFFF;
              z-index: 2;
              top: 12px;
              position:absolute;
              left:450px;
              border :2px solid #FFFFFF;
              width :750px;
              height: 500px;
              visibility:hidden;
              overflow:auto;
              text-align:center;"  >
                <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'divDetalle')"  >Aprobar Version</div>


                <center>
                    <div id="panelSeguimiento" style="overflow:auto;width:750px;height:500px;" >
                        <div id="div_productoModificado">

                        </div>
                    </div>
                </center>
                <button class="btn" onclick="aprobar_action();">Aprobar</button>
                <button class="btn" onclick="ocultarModal()">Cancelar</button>
            </div>
        <div  id="formsuper"  style=" padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    hidheidhedede
         </div>
            
            <h:form id="form1"  >
           
                <div align="center">
                    
                    <h:outputText value="#{ManagedComponentesProducto.cargarVersionesCompProdAprobar}"   />
                    <h3>Nuevos Productos Semiterminados</h3>
                    
                    <a4j:jsFunction action="#{ManagedComponentesProducto.aprobarComponenteProdVersion_action}"  name="aprobar_action" oncomplete="ocultarModal()" reRender="dataProductosVersion" />
                    <rich:dataTable value="#{ManagedComponentesProducto.componentesProdVersionesList}" var="data" id="dataProductosVersion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    binding = "#{ManagedComponentesProducto.componentesProdVersionNuevaDataTable}"
                                    >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"    />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="nro version"  />
                            </f:facet>
                            <h:outputText value="#{data.nroVersion}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Via Administración"  />
                            </f:facet>
                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadVolumen}" rendered="#{data.cantidadVolumen>0}">
                                <f:convertNumber pattern="###.##" locale="EN" />
                            </h:outputText>
                            <h:outputText value=" #{data.unidadMedidaVolumen.abreviatura}" rendered="#{data.cantidadVolumen>0}"/>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tolerancia Volumen a Fabricar"  />
                            </f:facet>
                            <h:outputText value="#{data.toleranciaVolumenfabricar}" rendered="#{data.toleranciaVolumenfabricar>0}" />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Concentración Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.concentracionEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Peso Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.pesoEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Color Presentación Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Sabor"  />
                            </f:facet>
                            <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Reg. Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Emisión R.S."  />
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimientoRS}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy"  />
                            </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Vida Util"  />
                            </f:facet>
                            <h:outputText value="#{data.vidaUtil}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                        </rich:column >

                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadosVersion.nombreEstadoVersion}"  />
                        </rich:column >

                        <rich:column styleClass="#{data.columnStyle}"  ><%--  rendered="#{ManagedComponentesProducto.opcionPresPrim}" --%>
                            <f:facet name="header">
                                <h:outputText value="EP"  />
                            </f:facet>
                             <a4j:commandLink  onclick="location='navegadorPresentacionesPrimariasVersion.jsf?codigo=#{data.codCompprod}&codVersion=#{data.codVersion}&direccion=navegador_componentesProductoVersionNuevos.jsf?codEstadoVersion=5'" >
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                            
                        </rich:column>
                        <rich:column styleClass="#{data.columnStyle}"  > <%-- rendered="#{ManagedComponentesProducto.opcionPresSecun}" --%>
                            <f:facet name="header">
                                <h:outputText value="ES"  />
                            </f:facet>
                            <a4j:commandLink  action="#{ManagedComponentesProducto.editarPresentacionesSecundarias_actionVersionNueva}" >
                                <f:param name="direccion" value="navegador_componentesProductoVersionNuevos.jsf?codEstadoVersion=5" />
                                <h:graphicImage url="../img/organigrama3.jpg"  alt="Etiquetas" />
                            </a4j:commandLink>
                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton styleClass="btn"
                        onclick="if(confirm('Esta seguro de solicitar aprobacion?')==false){return false;}"
                        action="#{ManagedComponentesProducto.solicitarAprobacionVersion_action}"
                        value="Solicitar Aprobacion" oncomplete="location='navegador_componentesProductoVersionNuevos.jsf?codEstadoVersion=5'"
                                        />

                        <a4j:commandButton  value="Editar"  styleClass="btn"
                        action="#{ManagedComponentesProducto.actionEditarVersion}"
                        oncomplete = "location = 'modificar_componentesProductoVersion.jsf'"  >
                            <f:param name="direccion" value="navegador_componentesProductoVersionNuevos.jsf?codEstadoVersion=5" />
                        </a4j:commandButton>
                        <a4j:commandButton styleClass="btn" action="#{ManagedComponentesProducto.eliminarComponentesProdVersion_action}"

                        value="Eiminar" oncomplete="location='navegador_componentesProductoVersionNuevos.jsf?codEstadoVersion=5'"
                                        />
                        
                    
                    
                </div>
                <!--cerrando la conexion onclick="return editarItem('form1:dataProductosVersion');" -->
            </h:form>

            

            
            
            
        </body>
    </html>
    
</f:view>

