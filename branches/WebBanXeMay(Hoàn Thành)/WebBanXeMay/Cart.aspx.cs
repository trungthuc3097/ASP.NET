﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebBanXeMay
{
    public partial class Cart : System.Web.UI.Page
    {
        ConnectDB DB = new ConnectDB();
        protected void msg_Delete(object sender, System.EventArgs e)
        {
            ((LinkButton)sender).Attributes["onclick"] = "return confirm('Bạn muốn có xóa sản phẩm này?')";
        }

        protected void msg_Order(object sender, System.EventArgs e)
        {
            ((LinkButton)sender).Attributes["onclick"] = "return confirm('Bạn muốn có đặt hàng các sản phẩm này?')";
        }
        AddProductCart cart = new AddProductCart();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["cart"] !=null)
            {
                
                DataTable dt = (DataTable)Session["cart"];
                rptProductCart.DataSource = dt;
                rptProductCart.DataBind();
                float total = 0;
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    total += Convert.ToSingle(dt.Rows[i]["ToTalMoney"]); 
                }
                ltTotal.Text = string.Format("{0:N0}", total);
            }
        }
        protected void rptProductCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    cart.ShoppingCart_RemoveOne(int.Parse(e.CommandArgument.ToString()));
                    Response.Redirect(Request.Url.ToString());
                    break;
                case "DelAll":
                    cart.ShoppingCart_Remove(int.Parse(e.CommandArgument.ToString()));
                    Response.Redirect(Request.Url.ToString());
                    break;
                    

            }
        }
        protected void lbtnThanhToan_Click(object sender, EventArgs e)
        {
            if (float.Parse(ltTotal.Text) > 0)
            {
                DataTable dt = (DataTable)Session["cart"];
                if (Session["idNguoiDung"] != null)
                {
                    bool kiemTra = false;
                    if (dt.Rows.Count > 0)
                    {
                        float tongTien = 0 ;
                        int soLuong = 0;
                        for (int i = 0; i < dt.Rows.Count; i++)
			            {
                            tongTien +=float.Parse(dt.Rows[0]["TotalMoney"].ToString());
			                soLuong += Convert.ToInt32(dt.Rows[i]["Quantity"].ToString());
			            }
                        if (DB.themorder(Convert.ToInt32(Session["idNguoiDung"].ToString()), tongTien,soLuong, DateTime.Now.ToString(), Session["hienThiTen"].ToString(), Session["PhoneND"].ToString(), Session["EmailND"].ToString(), Session["AddressND"].ToString()))
                        {
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                DataTable dtOrder = (DataTable)DB.getLidtOrder();
                                if (DB.themOrder_Dettail(Convert.ToInt32(dtOrder.Rows[(dtOrder.Rows.Count) - 1]["orders_id"].ToString()), Convert.ToInt32(dt.Rows[i]["PId"].ToString()),Convert.ToInt32(dt.Rows[i]["Quantity"].ToString()),float.Parse(dt.Rows[0]["TotalMoney"].ToString())))
                                {
                                    kiemTra = true;
                                }
                             }
                        }
                        else
                        {
                             kiemTra = false;
                        }
                        
                        if (kiemTra == true)
                        {
                            dt.Clear();
                            System.Web.HttpContext.Current.Session["cart"] = dt;
                            pnMsg.Visible = true;
                            lblMsg.Text = "Bạn đã đặt hàng thành công! Nhấn tiếp tục để mua tiếp.";

                        }
                        else
                            Response.Write("<script language=javascript>alert('Quá trình đặt hàng thất bại !');</script>");
                    }
                    else
                    {
                        string message = "<script language=javascript>alert('Bạn chưa có sản phẩm nào để thanh toán!');</script>";
                        Response.Write(message);
                    }
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }

            }
            else
            {
                string message = "<script language=javascript>alert('Bạn chưa có sản phẩm nào để thanh toán!');</script>";
                Response.Write(message);
            }
            
        }

        protected void btnTieptuc_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }


    }
}