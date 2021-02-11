<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Seller.Master" AutoEventWireup="true" CodeBehind="Seller_Profile.aspx.cs" Inherits="CncAgro.AccessSeller.Seller_Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="CSS/Seller_Profile.css?v=3" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <asp:FormView ID="SellerFormView" runat="server" DataKeyNames="RegistrationID" DataSourceID="SellerSQL" OnItemUpdated="SellerFormView_ItemUpdated" Width="100%">
        <EditItemTemplate>
            <div class="col-md-6 col-sm-12">
                <div class="form-group">
                    <label>Shop Name</label>
                    <asp:TextBox ID="TextBox5" runat="server" CssClass="form-control" Text='<%# Bind("Shop_Name") %>' />
                </div>
                <div class="form-group">
                    <label>Proprietor</label>
                    <asp:TextBox ID="TextBox6" runat="server" CssClass="form-control" Text='<%# Bind("Proprietor") %>' />
                </div>
                <div class="form-group">
                    <label>Name</label>
                    <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Text='<%# Bind("Name") %>' />
                </div>
                <div class="form-group">
                    <label>Father&#39;s Name:</label>
                    <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("FatherName") %>' />
                </div>
                <div class="form-group">
                    <label>Mobile:</label>
                    <asp:TextBox ID="TextBox3" runat="server" CssClass="form-control" Text='<%# Bind("Phone") %>' />
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <asp:TextBox ID="TextBox4" runat="server" CssClass="form-control" Text='<%# Bind("Email") %>' />
                </div>
                <div class="form-group">
                    <label>Shop Address:</label>
                    <asp:TextBox ID="Present_AddressTextBox" runat="server" CssClass="form-control" Text='<%# Bind("Present_Address") %>' TextMode="MultiLine" />
                </div>

                <div class="form-group">
                    <label>Image:</label>
                    <asp:FileUpload ID="ImageFileUpload" runat="server" />
                </div>

                <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="True" CommandName="Update" Text="Update" CssClass="btn btn-default" />
                &nbsp;<asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" CssClass="btn btn-default" />
            </div>
        </EditItemTemplate>
        <ItemTemplate>
            <div class="well user-info">
                <div class="Info">
                    <h3>
                        <i class="fa fa-shopping-cart"></i>
                        <%#Eval("Shop_Name") %>
                        <small><%#Eval("Seller_Type") %></small>
                    </h3>

                    <ul>
                        <li>
                            <i class="glyphicon glyphicon-user rest-userico"></i>
                            <b>Name:</b>
                            <%#Eval("Name") %>
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-earphone"></span>
                            <b>Mobile:</b>
                            <%# Eval("Phone") %>
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-envelope"></span>
                            <b>Email: </b>
                            <%# Eval("Email") %>
                        </li>
                        <li>
                            <span class="glyphicon glyphicon-map-marker"></span>
                            <b>Address: </b>
                            <%# Eval("Present_Address") %>
                        </li>
                    </ul>
                </div>

                <asp:LinkButton ID="LinkButton1" CssClass="btn btn-default" runat="server" CausesValidation="False" CommandName="Edit" Text="Update" />
            </div>

            <div class="alert alert-success">
                <h4 style="margin-bottom: 0; text-transform: none">Available Balance:
                    <%#Eval("Available_Balance","{0:N}") %> Tk
                </h4>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Registration.Name, Registration.FatherName, Registration.MotherName, Registration.DateofBirth, Registration.BloodGroup, Registration.Gender, Registration.NationalID, Registration.Present_Address, Registration.Permanent_Address, Registration.Phone, Registration.Email, Registration.CreateDate, Registration.RegistrationID, Seller.Shop_Name, Seller.Proprietor, Seller.Seller_Type, Seller.Available_Balance FROM Seller INNER JOIN Registration ON Seller.SellerRegistrationID = Registration.RegistrationID WHERE (Registration.RegistrationID = @RegistrationID)" UpdateCommand="UPDATE Registration SET Name = @Name, FatherName = @FatherName, Phone = @Phone, Email = @Email, Present_Address = @Present_Address WHERE (RegistrationID = @RegistrationID)
UPDATE  Seller SET  Shop_Name = @Shop_Name, Proprietor =@Proprietor WHERE  (SellerRegistrationID = @RegistrationID)">
        <SelectParameters>
            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Name" Type="String" />
            <asp:Parameter Name="FatherName" Type="String" />
            <asp:Parameter Name="Phone" Type="String" />
            <asp:Parameter Name="Email" />
            <asp:Parameter Name="Present_Address" />
            <asp:SessionParameter Name="RegistrationID" SessionField="RegistrationID" Type="Int32" />
            <asp:Parameter Name="Shop_Name" />
            <asp:Parameter Name="Proprietor" />
        </UpdateParameters>
    </asp:SqlDataSource>


    <div class="panel panel-default" style="display: none;" id="IsRequest">
        <div class="panel-heading">BALANCE REQUEST</div>
        <div class="panel-body">
            <div class="table-responsive">
                <asp:GridView ID="WithdrawGridView" runat="server" CssClass="mGrid" AutoGenerateColumns="False" DataKeyNames="Transition_CodeID" DataSourceID="RequestSQL">
                    <Columns>
                        <asp:TemplateField HeaderText="Delete" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" OnClientClick="return confirm('Are you sure want to delete?')" CommandName="Delete" Text="Delete"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="UserName" HeaderText="User id" SortExpression="UserName" />
                        <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                        <asp:BoundField DataField="Phone" HeaderText="Phone" SortExpression="Phone" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                        <asp:BoundField DataField="Insert_Date" DataFormatString="{0:d MMM yyyy}" HeaderText="Requested Date" SortExpression="Insert_Date" />
                        <asp:TemplateField HeaderText="Verify">
                            <ItemTemplate>
                                <a href="Code_Verify.aspx?id=<%# Eval("Transition_CodeID") %>">Verify</a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="RequestSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Fund_Transition_Code.Transition_CodeID, Registration.UserName, Registration.Name, Registration.Phone, Fund_Transition_Code.Amount, Fund_Transition_Code.Insert_Date FROM Fund_Transition_Code INNER JOIN Registration ON Fund_Transition_Code.Sent_RegistrationID = Registration.RegistrationID INNER JOIN Member ON Registration.RegistrationID = Member.MemberRegistrationID WHERE (Fund_Transition_Code.IS_Used = 0) AND (Fund_Transition_Code.Received_RegistrationID = @Received_RegistrationID)">
                    <SelectParameters>
                        <asp:SessionParameter Name="Received_RegistrationID" SessionField="RegistrationID" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </div>
    </div>

    <asp:FormView ID="Stock_FormView" runat="server" DataSourceID="StockSQL" Width="100%">
        <ItemTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">STOCK DETAILS</div>
                <div class="panel-body">
                    <div class="row text-center">
                        <div class="col-sm-4">
                            <div class="Total_Stock Box">
                                <h2><%# Eval("Total_Stock") %></h2>
                                <small>STOCK QUANTITY</small>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="Total_Price Box">
                                <h2><%# Eval("Total_Price") %> Tk</h2>
                                <small>TOTAL PRICE</small>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="Total_Point Box">
                                <h2><%# Eval("Total_Point") %></h2>
                                <small>TOTAL POINT</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="StockSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT SUM(Seller_Product.SellerProduct_Stock) AS Total_Stock, SUM(Seller_Product.SellerProduct_Stock * Product_Point_Code.Product_Point) AS Total_Point, SUM(Seller_Product.SellerProduct_Stock * Product_Point_Code.Product_Price) AS Total_Price FROM Seller_Product INNER JOIN Product_Point_Code ON Seller_Product.Product_PointID = Product_Point_Code.Product_PointID WHERE (Seller_Product.SellerID = @SellerID)">
        <SelectParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:FormView ID="Income_FormView" runat="server" DataKeyNames="SellerID" DataSourceID="SellerBalanceSQL" Width="100%">
        <ItemTemplate>
            <div class="panel panel-default">
                <div class="panel-heading">ACCOUNTS DETAILS</div>
                <div class="panel-body">
                    <div class="row text-center">
                        <div class="col-md-3 col-sm-6">
                            <div class="SellingPoint Box">
                                <h5><%# Eval("SellingPoint") %></h5>
                                <small>Selling Point</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="Selling_Income Box">
                                <a href="Commission_Records.aspx" title="Click to details">
                                    <h5><%#Eval("Selling_Income","{0:N}") %> Tk</h5>
                                    <small>Total Income <i class="fa fa-angle-right"></i></small>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="Withdraw Box">
                                <a href="Withdraw_Details.aspx" title="Click to details">
                                    <h5>Withdraw: <%#Eval("Withdraw_Balance","{0:N}") %> Tk <i class="fa fa-angle-right"></i></h5>
                                </a>
                                <a href="Received_Balance.aspx" title="Click to details">
                                    <h5>Received: <%#Eval("Received__Balance","{0:N}") %> Tk <i class="fa fa-angle-right"></i></h5>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="Balance Box">
                                <h5><%#Eval("Load_Balance","{0:N}") %> Tk</h5>
                                <small>Loaded Balance</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ItemTemplate>
    </asp:FormView>
    <asp:SqlDataSource ID="SellerBalanceSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT * FROM [Seller] WHERE ([SellerID] = @SellerID)">
        <SelectParameters>
            <asp:SessionParameter Name="SellerID" SessionField="SellerID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <script>
        $(function () {
            if ($("[id*=WithdrawGridView] tr").length) {
                $("#IsRequest").show();
            }
        })
    </script>
</asp:Content>
