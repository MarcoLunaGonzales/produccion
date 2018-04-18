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
            <script type="text/javascript" src="../js/general.js" ></script> 

            <script  type="text/javascript">
                function cogerId(obj){
                    alert(obj);
                 }

                function nuevoAjax()
                {	var xmlhttp=false;
                    try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (E) {
                            xmlhttp = false;
                        }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                        xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
                }
                function enviar(codigo,fecha_ini,fecha_fin){
                    //alert();

                    var ajax=nuevoAjax();
                    var valores='codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin;
                    valores+='&pq='+(Math.random()*1000);

                    var url='../reporteExplosionProductos/filtroReporteExplosion.jsf';



                    //alert(url);
                    ajax.open ('POST', url, true);
                    ajax.onreadystatechange = function() {

                        if (ajax.readyState==1) {

                        }else if(ajax.readyState==4){
                            // alert(ajax.status);
                            if(ajax.status==200){
                                //alert(ajax.responseText);
                                var mainGrupo=document.getElementById('panelCenter');
                                //mainGrupo.innerHTML=ajax.responseText;
                                document.write(ajax.responseText);

                                //f=0;
                                //Item(codigo,f);
                            }
                        }
                    }
                    ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
                    ajax.send(valores);
                }



               
            function verificarCantidad()
            {
                var cantidadReg=0;
                var valoresTabla=document.getElementById('form1:dataProgramaProduccion');
                var cantidadLote=parseFloat(document.getElementById('form1:cantidadLote').value);

                    for(var j=1;j<valoresTabla.rows.length;j++)
                    {
                        if(!(parseFloat(valoresTabla.rows[j].cells[2].getElementsByTagName('input')[0].value)>0))
                        {
                            alert('La cantidad de lote debe ser mayor a cero en la fila '+j);
                            return false;
                        }
                        cantidadReg+=parseFloat(valoresTabla.rows[j].cells[2].getElementsByTagName('input')[0].value);
                    }
                    if(cantidadReg<cantidadLote)
                    {
                       alert('No se puede registrar esta cantidad porque es menor a la cantidad del lote')
                       return false;
                    }
                    if(cantidadReg>cantidadLote)
                    {
                        alert('No se puede registrar esta  cantidad porque sobrepasa a la cantidad del lote')
                        return false;

                    }
                return true;

            }
            function verificar()
            {
                if(parseInt(document.getElementById('form1:cantidadLotes').value)<=0)
                 {
                    alert('La cantidad de lotes no puede ser menor o igual que cero');
                    return false;
                 }
                if(parseInt(document.getElementById('form1:codFormulaMaestra').value)<=0)
                    {
                        alert('Debe seleccionar el producto base del lote');
                        return false;
                    }


                        if(verificarCantidad())
                                    {
                                if(confirm('Esta seguro de guardar esta información?')==true)
                                {


                                    var valoresTabla=document.getElementById('form1:dataProgramaProduccion');
                                    if(!(valoresTabla.rows.length>1))
                                    {
                                        alert('No puede registrar sin detalle de productos');
                                        return false;
                                    }
                                   for(var i=1;i<valoresTabla.rows.length;i++)
                                   {
                                        if(parseInt(valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value)==0)
                                           {
                                               alert('Tiene que seleccionar el tipo de programa produccion en la fila '+i);
                                               return false;
                                           }
                                        for(var j=1;j<valoresTabla.rows.length;j++)
                                           {
                                               if(i!=j)
                                                   {
                                                     if(((valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[i].cells[1].getElementsByTagName('SELECT')[0].value)==(valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0]==null?'0':valoresTabla.rows[j].cells[1].getElementsByTagName('SELECT')[0].value))&&
                                                          (valoresTabla.rows[i].cells[3].getElementsByTagName('SELECT')[0].value==valoresTabla.rows[j].cells[3].getElementsByTagName('SELECT')[0].value))
                                                          {
                                                            alert('No puede registrar datos duplicados')
                                                            return false;
                                                          }


                                                   }
                                           }

                                   }
                                   return true;
                                }
                                else
                              {
                                  return false;
                              }
                      }
                      else
                          {
                              return false;
                          }
                    
              return false;

            }


            function calcularCantidadPresentacion(celda)
            {
                
                var cantidadProductoPorPresentacion=celda.parentNode.parentNode.cells[4].getElementsByTagName('span')[0].innerHTML;
                celda.parentNode.parentNode.cells[7].getElementsByTagName('input')[0].value=(parseFloat(celda.value)/parseFloat(cantidadProductoPorPresentacion));
                celda.parentNode.parentNode.cells[7].getElementsByTagName('span')[0].innerHTML=(parseFloat(celda.value)/parseFloat(cantidadProductoPorPresentacion));
                

            }
            function verReporteMateriales(codCotizacionVentasDemanda){
                    window.open('reporteMaterialesCotizacionesVentasDemanda.jsf?codCotizacionVentasDemanda='+codCotizacionVentasDemanda,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
            }
            function tieneDecimales(n) {
                //return n % 1 != 0;
                
                if((n % 1)!=0)
                    return false;
                else
                    return true;
            }
            function validarCantidadClientesNoMayorCantidadLicitacion()
            {
                var tabla=document.getElementById("form6:dataCotizacionesVentasDemanda");
                
                var sumaCantidad=0;
                for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tieneDecimales(parseFloat(tabla.rows[i].cells[7].getElementsByTagName('span')[0].innerHTML))==false)
                        {
                            alert('No se puede registrar una cantidad que equivale a decimales en unidades de la presentación');
                             return false;
                        }
                        if(parseFloat(tabla.rows[i].cells[6].getElementsByTagName('input')[0].value)>parseFloat(tabla.rows[i].cells[5].getElementsByTagName('span')[0].innerHTML))
                        {
                            alert('La cantidad de produccion registrada en la fila '+i+' no se puede registrar ya que sobrepasa la cantidad de la demanda');
                            return false;
                        }
                        sumaCantidad+=parseFloat(tabla.rows[i].cells[6].getElementsByTagName('input')[0].value);
                    }
                    var cantidadPermitida=document.getElementById("form6:cantidadLicitacion").innerHTML;
                if(parseFloat(cantidadPermitida)<sumaCantidad)
                    {
                        alert('No se puede registrar estas cantidades ya que sobrepasan la cantidad asignada a licitacion');
                        return false;
                    }
                else
                    {
                        return true;
                    }
                return false;
            }
            function valEnteros()
            {
              if ((event.keyCode < 48 || event.keyCode > 57) )
                 {
                    alert('Introduzca solo Numeros Enteros');
                    event.returnValue = false;
                 }
            }
         </script>

        </head>
            <body>

            
            <a4j:form id="form1"   >
                <div align="center" >
                    <br><br>
                        <h:outputText value="#{ManagedProgramaProduccionDesarrollo.cargarContenidoAgregarProgramaProduccionDesarrollo}" />
                     <rich:panel id="panelTransacciones" styleClass="panelBuscar" >
                        <f:facet name="header">
                            <h:outputText value="Por favor cambie la fecha" />
                        </f:facet>
                        <a4j:commandButton value="Aceptar" id="botonT" reRender="fechaComprobante,codAreaEmpresa,fechaOculta" styleClass="commandButton"   actionListener="#{ManagedRegistroComprobantesCajaChica.transaccionIncorrecta}" onclick="document.getElementById('form1:panelTransacciones').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';" />

                      </rich:panel>
                     
                    Producto:
                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccionDesarrollo.programaProduccionbean.formulaMaestra.codFormulaMaestra}"
                                          id="codFormulaMaestra">
                            <f:selectItems value="#{ManagedProgramaProduccionDesarrollo.formulaMaestraList}"/>
                            <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesarrollo.formulaMaestra_change1}" reRender="dataProgramaProduccion,cantidadLote"
                            />
                     </h:selectOneMenu><br/><br/>
                     Cantidad Lotes: <h:inputText value="#{ManagedProgramaProduccionDesarrollo.programaProduccionbean.nroLotes}" styleClass="inputText" onkeypress="valEnteros()" id="cantidadLotes"/>
                     <h:inputHidden value="#{ManagedProgramaProduccionDesarrollo.programaProduccionbean.formulaMaestra.cantidadLote}" id="cantidadLote" />
                     <br/>
                     <br/>
                    
                     <h:panelGroup id="panelContenidoAgregarProgramaProduccionSimulacion" >
                         <rich:dataTable value="#{ManagedProgramaProduccionDesarrollo.programaProduccionAgregarList}" var="data"
                                    id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionDesarrollo.programaProduccionAgregarDataTable}">
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value=""  />
                                </f:facet>
                                <h:selectBooleanCheckbox value="#{data.checked}"  />
                            </rich:column>
                            <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:selectOneMenu value="#{data.formulaMaestra.componentesProd.codCompprod}" styleClass="inputText">
                                <f:selectItems value="#{data.productosList}"/>
                                <a4j:support event="onchange" action="#{ManagedProgramaProduccionDesarrollo.onChangeProductoAgregar}" reRender="panelContenidoAgregarProgramaProduccionSimulacion"/>
                            </h:selectOneMenu>
                            
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Cantidad Lote"  />
                                </f:facet>
                                <h:inputText value="#{data.cantidadLote}" styleClass="inputText"  onkeypress="valEnteros()"/>
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Tipo Programa Produccion"  />
                                </f:facet>
                                <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccionDesarrollo.tiposProgramaProdList}" />
                                    <a4j:support action="#{ManagedProgramaProduccionDesarrollo.tipoProgramaProduccion_change}" reRender="panelContenidoAgregarProgramaProduccionSimulacion"  event="onchange" />
                                </h:selectOneMenu>
                            </rich:column>
                             <%--h:column>
                                <f:facet name="header">
                                    <h:outputText value="Demanda Cliente"  />
                                </f:facet>
                                <a4j:commandLink onclick="Richfaces.showModalPanel('panelCotizacionesVentasDemanda')" rendered="#{data.tiposProgramaProduccion.codTipoProgramaProd eq '2'}"
                                action="#{ManagedProgramaProduccion.registrarDemandaDeClientes_Action}"
                                    reRender="contenidoCotizacionesVentasDemanda">
                                    <h:graphicImage url="../img/organigrama3.jpg" alt="Materia Prima" />
                                </a4j:commandLink>
                                
                            </h:column--%>
                    </rich:dataTable>
                    </h:panelGroup>
                     <br/>
                     <center>
                         <a4j:commandLink action="#{ManagedProgramaProduccionDesarrollo.mas_ActionAgregar}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccionDesarrollo.menos_ActionAgregar}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                        </center>
                    <br>
                    <br />
                    <h:outputText value="fecha de Lote::" styleClass="outputText2" />
                    <h:panelGroup>
                        <h:inputText value="#{ManagedProgramaProduccionDesarrollo.fechaLote}"   styleClass="inputText"  id="fechaLote"  size="15" onblur="valFecha(this);" >
                             <f:convertDateTime pattern="dd/MM/yyyy"   />
                    </h:inputText>
                    <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha2" />
                    <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaLote' click_element_id='form1:imagenFecha2'></DLCALENDAR>"  escape="false"  />
                    </h:panelGroup>
                    <br />
                    
                    <a4j:commandButton value="Guardar" styleClass="btn" type="button" action="#{ManagedProgramaProduccionDesarrollo.guardarProgramaProduccion_action1}"    onclick="if(verificar()==false){return false;}"
                    oncomplete="if(#{ManagedProgramaProduccionDesarrollo.mensaje !=''}){alert('#{ManagedProgramaProduccionDesarrollo.mensaje}');}else{location.href='navegador_programa_produccion_desarrollo.jsf';alert('Se registro el lote de Producción');}" />
                    <%--inicio ale ultimo--%>
                    <a4j:commandButton value="Limpiar" styleClass="btn"  action="#{ManagedProgramaProduccionDesarrollo.limpiar_action}" reRender="form1" />
                    <%--final ale ultimo--%>
                    <input type="button" class="btn" onclick="window.location='navegador_programa_produccion_desarrollo.jsf'" value="Cancelar" />
                    

                    

                
            </a4j:form>

                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                     </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
            
             


            </div>
            
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>


