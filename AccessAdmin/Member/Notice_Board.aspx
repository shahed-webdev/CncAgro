<%@ Page Title="Notice Board" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="Notice_Board.aspx.cs" Inherits="CncAgro.AccessAdmin.Member.Notice_Board" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .mGrid { text-align: left; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Add Notice For All Customers</h3>

    <div class="row">
        <div class="col-md-6 col-sm-12">
            <div class="card card-body">
                <div class="form-group">
                    <label>Notice Title<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Notice_TitleTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="N"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="Notice_TitleTextBox" placeholder="Notice Title" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Show From Date<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="ShowFromDateTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="N"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="ShowFromDateTextBox" placeholder="From Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control datepicker"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Show To Date<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ShowToDateTextBox" CssClass="EroorStar" ErrorMessage="Required" ValidationGroup="N"></asp:RequiredFieldValidator></label>
                    <asp:TextBox ID="ShowToDateTextBox" placeholder="To Date" onkeypress="return isNumberKey(event)" autocomplete="off" onDrop="blur();return false;" onpaste="return false" runat="server" CssClass="form-control datepicker"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Notice Image (Optional)</label>
                    <asp:FileUpload ID="Notice_ImageFileUpload" runat="server" />
                </div>
                <div class="form-group">
                    <label>Notice (Text)</label>
                    <asp:TextBox ID="NoticeTextBox" placeholder="Notice Text" runat="server" CssClass="form-control" TextMode="MultiLine"></asp:TextBox>
                </div>

                <asp:Button ID="SubmitButton" runat="server" CssClass="btn btn-primary" Text="Submit" OnClick="SubmitButton_Click" ValidationGroup="N" />
                <asp:SqlDataSource ID="NoticeSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" DeleteCommand="DELETE FROM [Noticeboard_General] WHERE [Noticeboard_General_ID] = @Noticeboard_General_ID" InsertCommand="INSERT INTO Noticeboard_General(Notice_Title, Notice, Start_Date, End_Date) VALUES (@Notice_Title, @Notice, @Start_Date, @End_Date)" SelectCommand="SELECT * FROM [Noticeboard_General]" UpdateCommand="UPDATE Noticeboard_General SET Notice_Title = @Notice_Title, Notice = @Notice, Start_Date = @Start_Date, End_Date = @End_Date WHERE (Noticeboard_General_ID = @Noticeboard_General_ID)">
                    <DeleteParameters>
                        <asp:Parameter Name="Noticeboard_General_ID" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:ControlParameter ControlID="Notice_TitleTextBox" Name="Notice_Title" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="NoticeTextBox" Name="Notice" PropertyName="Text" Type="String" />
                        <asp:ControlParameter ControlID="ShowFromDateTextBox" DbType="Date" Name="Start_Date" PropertyName="Text" />
                        <asp:ControlParameter ControlID="ShowToDateTextBox" DbType="Date" Name="End_Date" PropertyName="Text" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Notice_Title" Type="String" />
                        <asp:Parameter Name="Notice" Type="String" />
                        <asp:Parameter DbType="Date" Name="Start_Date" />
                        <asp:Parameter DbType="Date" Name="End_Date" />
                        <asp:Parameter Name="Noticeboard_General_ID" Type="Int32" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>
        </div>
    </div>

    <div class="table-responsive">
        <asp:GridView ID="Notice_GridView" runat="server" CssClass="mGrid" AutoGenerateColumns="False" DataKeyNames="Noticeboard_General_ID" DataSourceID="NoticeSQL">
            <Columns>
                <asp:TemplateField HeaderText="Notice">
                    <ItemTemplate>
                        <div>
                            <h4>
                                <asp:Label ID="Label3" runat="server" Text='<%# Bind("Notice_Title") %>'></asp:Label></h4>
                        </div>

                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Notice") %>'></asp:Label>

                        <div>
                            <div><strong>Display Date</strong></div>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("Start_Date", "{0:d MMM yyyy}") %>'></asp:Label>
                            TO
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("End_Date", "{0:d MMM yyyy}") %>'></asp:Label>
                        </div>

                        Add Date:
                            <asp:Label ID="Label5" runat="server" Text='<%# Bind("Insert_Date", "{0:d MMM yyyy}") %>'></asp:Label>

                        <div>
                            <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit Notice"></asp:LinkButton>
                            |
                            <asp:LinkButton ID="LinkButton4" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" OnClientClick="return confirm('are you sure want to delete?')"></asp:LinkButton>
                        </div>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <div class="form-group">
                            <label>Notice Title</label>
                            <asp:TextBox ID="TextBox3" CssClass="form-control" runat="server" Text='<%# Bind("Notice_Title") %>'></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Notice</label>
                            <asp:TextBox ID="TextBox4" CssClass="form-control" runat="server" TextMode="MultiLine" Text='<%# Bind("Notice") %>'></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Display From Date</label>
                            <asp:TextBox ID="TextBox1" CssClass="form-control datepicker" runat="server" Text='<%# Bind("Start_Date", "{0:d MMM yyyy}") %>'></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Display To Date</label>
                            <asp:TextBox ID="TextBox2" CssClass="form-control datepicker" runat="server" Text='<%# Bind("End_Date", "{0:d MMM yyyy}") %>'></asp:TextBox>
                        </div>

                        <asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="True" CommandName="Update" Text="Update"></asp:LinkButton>
                        <asp:LinkButton ID="LinkButton3" runat="server" CausesValidation="True" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                    </EditItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>


    <script type="text/javascript">
        $(function () {
            $('.datepicker').datepicker({
                format: 'dd M yyyy',
                todayBtn: "linked",
                todayHighlight: true,
                autoclose: true
            });
        });

        function isNumberKey(a) { a = a.which ? a.which : event.keyCode; return 46 != a && 31 < a && (48 > a || 57 < a) ? !1 : !0 };
    </script>
</asp:Content>
