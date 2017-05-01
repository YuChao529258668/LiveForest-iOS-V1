/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Created by apple on 15/8/25.
	 */

	/**
	 *@region 接口引入
	 */
	"use strict";

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

	var _wechatJsx = __webpack_require__(1);

	var _wechatJsx2 = _interopRequireDefault(_wechatJsx);

	var _modelJs = __webpack_require__(3);

	var _pluginsJs = __webpack_require__(4);

	/**
	 * @function 界面适配配置
	 */
	var $ = __webpack_require__(2);

	;
	(function (win, doc, $, undefined) {
	    var conf = {
	        'name': 'RongCloudWebSDK',
	        'isPCBrowser': false,
	        'keyboardHeight': 0,
	        'winWidth': 0,
	        'winHeight': 0,
	        'statuHeight': 0,
	        'RongIMVoice': false
	    };
	    conf.pc = {
	        'MinWidth': 960,
	        'FooterMinHeight': 60,
	        'Mt': $(".left").css('margin-top'),
	        'Mb': 20
	    };
	    conf.scroll = {
	        'cursorcolor': "#78d0f4",
	        'cursoropacitymax': 1,
	        'touchbehavior': true,
	        'cursorwidth': "5px",
	        'cursorborder': "0",
	        'cursorborderradius': "5px"
	    };
	    conf.popBox = {
	        'title': '创建讨论组',
	        'left_subtitle': '我的好友',
	        'defaultTitle': '讨论组', //只读，不建议代码修改
	        'discussionTitle': '讨论组',
	        'right_subtitle': '已选择的好友'
	    };
	    conf.popBox.html = {};
	    conf.popBox.html.discussion = ['<div class="light_popBox_backlayer"></div>', '<div class="popBox_frontlayer">', '<div class="light_popBox_MainWrapper">', '<div class="light_popBox_title">', '<span style="float:left" onselectstart="return false">' + conf.popBox.title + '</span>', '<span style=""><font class="discussionTitle" style="margin-left: 0px; line-height: 16px;">' + conf.popBox.defaultTitle + '</font><font class="pen"></font></span>', '<span class="light_popBox_close">', '<a href="javascript:void(0)" onselectstart="return false" id="light_popBox_close">', '<img style="margin-top:12px;" src="./static/images/icon_close.png">', '</a>', '</span>', '</div>', '<div class="light_popBox_content">', '<div class="light_popBox_friendList">', '<div class="discussion_subtitle"><span>' + conf.popBox.left_subtitle + '</span></div>', '<div class="discussion_listAddr"><ul></ul></div>', '</div>', '<div class="discussion_userList">', '<div class="discussion_subtitle"><span>' + conf.popBox.right_subtitle + '</span></div>', '<div class="discussion_listAddr"><ul></ul></div>', '</div>', '</div>', '<div class="light_popBox_opear">', '<span class="light_popBox_notice">最多只能选择49个好友</span>', '<span class="sub">', '<a href="javascript:void(0)" target="_blank">立即创建</a>', '</span>', '</div></div>', '</div>'].join('');
	    var lib = {};
	    lib.clone = function (obj) {
	        var that = this;
	        if (typeof obj != 'object') return obj;
	        if (obj == null) return obj;
	        var newObj = {};
	        for (var i in obj) {
	            newObj[i] = that.clone(obj[i]);
	        }
	        return newObj;
	    };
	    lib.delay = function (d) {
	        for (var t = Date.now(); Date.now() - t <= d;);
	    };
	    lib.uniqueArray = function (arr) {
	        var res = [];
	        var json = {};
	        for (var i = 0; i < arr.length; i++) {
	            if (!json[arr[i]]) {
	                res.push(arr[i]);
	                json[arr[i]] = 1;
	            }
	        }
	        return res;
	    };

	    //经常用的是通过遍历,重构数组.
	    Array.prototype.remove = function (val) {
	        var dx = this.getIndexByValue(val);
	        if (isNaN(dx) || dx > this.length) {
	            return false;
	        }
	        for (var i = 0, n = 0; i < this.length; i++) {
	            if (this[i] != this[dx]) {
	                this[n++] = this[i];
	            }
	        }
	        this.length -= 1;
	    };

	    //在数组中获取指定值的元素索引
	    Array.prototype.getIndexByValue = function (value) {
	        var index = -1;
	        for (var i = 0; i < this.length; i++) {
	            if (this[i] == value) {
	                index = i;
	                break;
	            }
	        }
	        return index;
	    };

	    var self = {};
	    self.conf = conf;
	    self.isPCBrowser = function () {
	        conf.winWidth = $(window).width();
	        return conf.winWidth > conf.pc.MinWidth;
	    };

	    self.setBoxHeight = function (heigh) {
	        var winHeight = $(window).height();
	        if (heigh && typeof heigh == "number") {
	            winHeight = heigh;
	        }
	        ;

	        var otherHeight = 0;
	        if (self.isPCBrowser()) {
	            otherHeight = conf.pc.FooterMinHeight + conf.pc.Mb + 25; //上下空隙间距
	            $(".bro_notice").show();
	            $(".left").show();
	            $(".right_box").show();
	        } else {
	            if ($(".right_box").is(":visible") == true) {
	                $(".left").hide();
	            }
	        }
	        var intBoxHeight = winHeight - otherHeight;
	        var intBoxMinHeight = $(".left").css('min-height');
	        intBoxMinHeight = parseInt(intBoxMinHeight);
	        if (intBoxHeight > intBoxMinHeight) {
	            $(".left").height(intBoxHeight);
	            $(".right_box").height(intBoxHeight);
	        } else {
	            $(".left").height(intBoxMinHeight);
	            $(".right_box").height(intBoxMinHeight);
	        }
	        $(".right").height($(".right_box").height());
	        self.setListHeight();
	        self.setDialogBoxHeight();
	    };
	    self.setListHeight = function () {
	        var intListHeight = 0;
	        var intHeaderHeight = $(".dialog_header").height();
	        var intOperHeight = 0;
	        var boxMb = 0;
	        if ($(".listOperatorContent") && $(".listOperatorContent").is(":visible")) {
	            intOperHeight = $(".listOperatorContent").height();
	            boxMb = conf.pc.Mb;
	        }
	        var intBoxHeight = $(".left").height();
	        intListHeight = intBoxHeight - intHeaderHeight - intOperHeight - boxMb;
	        $(".list").height(intListHeight);
	    };
	    self.setDialogBoxHeight = function () {
	        var intBoxHeight = $(".right").height();
	        var intMsgBoxHeight = 0;
	        if (self.isPCBrowser()) {
	            intMsgBoxHeight = $(".msg_box").outerHeight();
	        } else {
	            intMsgBoxHeight = 44;
	        }
	        var otherHeight = intMsgBoxHeight + $(".dialog_box_header").outerHeight();
	        if ($(".pagetion_list") && $(".pagetion_list").is(":visible") == true) {
	            otherHeight = $(".pagetion_list").height() + conf.pc.Mb;
	        }
	        var msgBoxHeight = intBoxHeight - otherHeight;
	        $(".dialog_box").css('height', msgBoxHeight);
	    };
	    /**
	     * 定位单条未读消息数
	     */
	    self.locateNum = function (index, obj) {
	        var padding = 3;
	        var intWidth = $(obj).width();
	        var val = $(obj).html();
	        if (val && val > 0) {
	            $(obj).css('display', 'inline-block');
	            $(obj).css('padding', padding);
	            $(obj).css('margin-left', -intWidth / 2 - 6);
	        } else {
	            $(obj).hide();
	        }
	    };
	    self.locateMsgStatu = function (index, obj) {
	        var prevHeight = $(obj).prev("div").height();
	        var marTop = (prevHeight - $(obj).height()) / 2 + 1.5 * $(obj).height();
	        $(obj).css("margin-top", -marTop);
	    };

	    /**
	     * @function 设置返回按钮
	     */
	    self.back = function () {
	        if ($(".right_box").is(":visible")) {
	            $(".right_box").hide();
	            $(".left").show();
	            if (!$(".listAddr").is(":visible")) {
	                $(".listConversation").hide();
	                $(".listConversation").show();
	            } else {
	                $(".listAddr").hide();
	                $(".listAddr").show();
	            }
	        } else {
	            $(".listAddr").hide();
	            $(".listConversation").show();
	            $(".logOut").show();
	            $(".addrBtnBack").hide();
	        }
	    };
	    var popBox = {};
	    var discussionList = {
	        'currentDiscusionUserList': [], //当前讨论组的用户列表
	        'newUserList': [], //添加或删除生成的讨论组临时用户列表
	        'newDiscussionTitle': conf.popBox.newDiscussionTitle //新建讨论组绑定popBox title
	    };
	    var discussion = {};
	    /**
	     * 修改讨论组名称
	     */
	    discussion.changeTitle = function (ev) {
	        var objTitle = $(this).prev("font");
	        if ($(this).text() == '确认') {
	            conf.popBox.discussionTitle = objTitle.text();
	            objTitle.removeAttr('contenteditable');
	            objTitle.css('border', 'none');
	            $(this).text('');
	            $(this).removeAttr('style');
	            $(this).css({
	                width: '16px'
	            });
	        } else if ($(this).text() == '') {
	            objTitle.selectstart = function () {};
	            objTitle.attr('contenteditable', 'true').css({
	                "cursor": 'initial',
	                "border-bottom": '1px solid #333'
	            });
	            $(this).css({
	                width: 'auto',
	                background: 'none'
	            }).text("确认");
	        }
	        ;
	    };
	    /**
	     * 讨论组添加成员
	     */
	    discussion.addUserTodiscussion = function (ev) {
	        var obj = $(this);
	        var userId = $(this).attr('targetid');
	        discussionList.newUserList = discussionList.currentDiscusionUserList;
	        var userToDiscussionObj = $(".discussion_userList .discussion_listAddr").find("ul");
	        if (obj.hasClass('discussion_selected')) {
	            obj.removeClass('discussion_selected').removeClass('discussion_selected_delete');
	            discussionList.newUserList.remove(userId);
	            userToDiscussionObj.find("li").each(function (index, el) {
	                if ($(this).attr("targetid") == userId) {
	                    $(this).remove();
	                    return false;
	                }
	                ;
	            });
	        } else {
	            obj.addClass('discussion_selected');
	            discussionList.newUserList.push(userId);
	            var userToDiscussionStr = '<li targetType="4" targetId="{0}" targetName="{1}"><span class="user_img"><img src="static/images/personPhoto.png"/></span> <span class="user_name">{1}</span><a href="javascript:void(0)" class="discussion_delete_user"></a></li>';
	            var _html = String.stringFormat(userToDiscussionStr, userId, obj.attr("targetname"));
	            userToDiscussionObj.append(_html);
	        }
	        discussionList.newUserList = lib.uniqueArray(discussionList.newUserList);
	    };
	    /**
	     * 从讨论组临时列表删除
	     */
	    discussion.removeUserFromList = function (ev) {
	        var objParent = $(this).parent();
	        var userId = objParent.attr("targetid");
	        var friendListObj = $(".light_popBox_friendList");
	        friendListObj.find("li").each(function (index, el) {
	            if ($(this).attr("targetid") == userId) {
	                $(this).removeClass('discussion_selected');
	                objParent.remove();
	                discussionList.newUserList.remove(userId);
	                return false;
	            }
	            ;
	        });
	        discussionList.newUserList = lib.uniqueArray(discussionList.newUserList);
	    };
	    /**
	     * 加载好友列表
	     * @return {[type]} [description]
	     */
	    popBox.init = function () {
	        var friendList = [{ "id": "6751", "username": "李淼", "portrait": "" }, {
	            "id": "6752",
	            "username": "vee",
	            "portrait": "http:\/\/www.gravatar.com\/avatar\/97d271900631dc9ea9810a1784b4407b?s=82"
	        }, {
	            "id": "6754",
	            "username": "Ariel@iPhone",
	            "portrait": "http:\/\/www.gravatar.com\/avatar\/3f56d1043edd4b9657c465ac7a507067?s=82"
	        }];
	        for (i in friendList) {
	            var friendListObj = $(".light_popBox_friendList .discussion_listAddr").find("ul");
	            var item = friendList[i];
	            var friendListStr = '<li targetType="4" targetId="{0}" targetName="{1}"><span class="user_img"><img src="static/images/personPhoto.png"/></span> <span class="user_name">{1}</span><a href="javascript:void(0)" class="discussion_select_user"></a></li>';
	            var _html = String.stringFormat(friendListStr, item.id, item.username);
	            friendListObj.append(_html);
	        }
	        ;
	    };
	    /**
	     * 绑定弹出窗口的事件
	     * @return {[type]} [description]
	     */
	    popBox.bind = function () {
	        popBox.reLocate();
	        $(window).bind("resize", popBox.reLocate);
	        var light_app_obj = $(".light_popBox_title");
	        light_app_obj.on("mousedown", popBox.move);
	        $(".light_popBox_title").off('mousedown');
	        $(".light_popBox_title").delegate('font.pen', 'click', discussion.changeTitle);
	        $(".light_popBox_friendList").delegate('.discussion_selected', 'mouseover', function (event) {
	            $(this).addClass('discussion_selected_delete');
	        }); //好友列表选择
	        $(".light_popBox_friendList").delegate('.discussion_selected', 'mouseout', function (event) {
	            $(this).removeClass('discussion_selected_delete');
	        }); //好友列表选择
	        $(".discussion_userList").delegate('.discussion_delete_user', 'click', discussion.removeUserFromList); //讨论组临时列表
	        $(".light_popBox_friendList .discussion_listAddr").delegate('li', 'click', discussion.addUserTodiscussion); //好友列表选择
	        $(".light_popBox_close").bind('click', popBox.close);
	    };
	    /**
	     * 关闭讨论组创建窗口
	     * @return {[type]} [description]
	     */
	    popBox.close = function (ev) {
	        discussionList.newUserList = [];
	        $(".popBox_frontlayer").remove();
	        $(".light_popBox_backlayer").remove();
	    };

	    /**
	     * 重定位弹框
	     * @return {[type]} [description]
	     */
	    popBox.reLocate = function () {
	        if ($(".light_popBox_MainWrapper").length > 0) {
	            var winHeight = document.documentElement.clientHeight || document.body.clientHeight;
	            var winWidth = document.documentElement.clientWidth || document.body.clientWidth;
	            var height = $(".light_popBox_MainWrapper").height();
	            var width = $(".light_popBox_MainWrapper").width();
	            var left = winWidth / 2 - width / 2;
	            var top = winHeight / 2 - height / 2;
	            $(".light_popBox_MainWrapper").css("top", top + "px");
	            $(".light_popBox_MainWrapper").css("left", left + "px");
	        }
	    };
	    /**
	     * 移动弹框
	     * @param  {[type]} ev [description]
	     * @return {[type]}    [description]
	     */
	    popBox.move = function (ev) {
	        var oDiv = $(".light_popBox_MainWrapper").get(0);
	        var oEvent = ev || event;
	        var dargX = oEvent.clientX - oDiv.offsetLeft;
	        var dargY = oEvent.clientY - oDiv.offsetTop;
	        document.onmousemove = function (ev) {
	            var oEvent = ev || event;
	            var Left = oEvent.clientX - dargX;
	            var Top = oEvent.clientY - dargY;
	            if (Left < 0) {
	                Left = 0;
	            }
	            if (Left > document.documentElement.clientWidth - oDiv.offsetWidth) {
	                Left = document.documentElement.clientWidth - oDiv.offsetWidth;
	            }
	            if (Top < 0) {
	                Top = 0;
	            }
	            if (Top > document.documentElement.clientHeight - oDiv.offsetHeight) {
	                Top = document.documentElement.clientHeight - oDiv.offsetHeight;
	            }
	            oDiv.style.left = Left + "px";
	            oDiv.style.top = Top + "px";
	        };
	        document.onmouseup = function () {
	            document.onmousemove = null;
	            document.onmouseup = null;
	        };
	        return false;
	    };
	    /**
	     * 创建讨论组
	     * @return {[type]} [description]
	     */
	    self.createDiscussion = function () {
	        //新建聊天组，存储临时聊天组用户列表
	        discussionList.newDiscusion = {};
	        var html = conf.popBox.html.discussion;
	        $("body").append(html);
	        popBox.init();
	        popBox.bind();
	        $(".settingView").hide();
	    };

	    self.createOrientationChangeProxy = function (fn) {
	        return function () {
	            if ($(".RongIMexpressionWrap").is(":visible")) {
	                $("#RongIMexpression").trigger('click');
	            }
	            ;
	            $(".textarea").blur();
	            clearTimeout(fn.orientationChangeTimer);
	            var args = Array.prototype.slice.call(arguments, 0);
	            fn.orientationChangeTimer = setTimeout(function () {
	                var ori = window.orientation;
	                if (ori != fn.lastOrientation) {
	                    fn.apply(null, args);
	                }
	                fn.lastOrientation = ori;
	            }, 800);
	        };
	    };
	    self.changeView = function () {
	        setTimeout(function () {
	            var height = 0;
	            $(".textarea").focus();
	            window.scrollTo(0, 0);
	            if (window.orientation == 180 || window.orientation == 0) {
	                height = self.winHeight - conf.statuHeight;
	                //$("body").append('<link href="/static/css/main.css" rel="stylesheet">');
	            } else {
	                    height = self.winWidth - conf.statuHeight;
	                    //$("body").append('<link href="/static/css/main.css" rel="stylesheet">');
	                }
	            self.setBoxHeight();
	        }, 500);
	    };
	    self.setStatuHeight = function () {
	        var winBodyHeight = $(window).height();
	        var height = 0;
	        if (window.orientation == 180 || window.orientation == 0) {
	            height = window.screen.height - winBodyHeight;
	        } else {
	            height = window.screen.width - winBodyHeight;
	        }
	        conf.statuHeight = height;
	    };
	    self.bind = function () {
	        self.winHeight = window.screen.height;
	        self.winWidth = window.screen.width;
	        self.setStatuHeight();
	        if ('onorientationchange' in window) {
	            window.addEventListener("orientationchange", self.createOrientationChangeProxy(function () {
	                if (window.orientation == 0 || window.orientation == 180 || window.orientation == 90 || window.orientation == -90) {
	                    self.changeView();
	                }
	            }), false);
	        } else {
	            $(window).bind("resize", self.setBoxHeight);
	        }
	        $("#createDiscussion").on('click', self.createDiscussion);
	        $(".conversation_msg_num").on('change', self.locateNum);
	        $(".status").on('change', self.locateMsgStatu);
	        $(".btnBack").on('click', self.back);
	        $(".setting").bind('click', function () {
	            $(".settingView").toggle();
	        });
	        $(".conversationBtn").click(function (event) {
	            $(".phone_dialog_header>.logOut").show();
	            $(".addrBtnBack").hide();
	            $(".conversationBtn").addClass('selected');
	            $(".addrBtn").removeClass('selected');
	            $(".list").hide();
	            $(".listConversation").show();
	        });
	        $(".addrBtn").click(function (event) {
	            $(".phone_dialog_header>.logOut").hide();
	            $(".addrBtnBack").show();
	            $(".addrBtn").addClass('selected');
	            $(".conversationBtn").removeClass('selected');
	            $(".list").hide();
	            $(".listAddr").show();
	        });
	        $("#RongIMexpression").bind('click', function () {
	            var RongIMexpressionObj = $(".RongIMexpressionWrap");
	            var intExpressHeight = RongIMexpressionObj.innerHeight();
	            if (RongIMexpressionObj.is(":visible")) {
	                $(".dialog_box").height($(".dialog_box").height() + intExpressHeight);
	                RongIMexpressionObj.hide();
	            } else {
	                $(".dialog_box").height($(".dialog_box").height() - intExpressHeight);
	                RongIMexpressionObj.show();
	            }
	            // RongIMexpressionObj.slideToggle();
	        });
	        $(".textarea").bind('focus', self.virtualKeyboardHeight);
	        //        $("body").bind('click', function() {$(this).trigger('mouseleave');alert(1111);});
	        $(".list").delegate('li', 'click', function () {
	            if (!self.isPCBrowser()) {
	                $(".left").hide();
	                $(".right_box").show();
	            }
	            ;
	        });
	        $(".dialog_box").bind('DOMNodeInserted', self.autoScroll);
	        $(".dialog_box").delegate('img', 'click', function (event) {
	            var url = $(this).attr('bigUrl');
	            self.showImg({ 'img': url, 'oncomplete': self.showBigImg });
	        });
	        $(".dialog_box").delegate('.voice', 'click', function (event) {
	            if (typeof conf.RongIMVoice == 'boolean' && conf.RongIMVoice) {
	                RongIMClient.voice.play($(this).next().val());
	            }
	        });

	        $("body").delegate('.light_notice_backlayer', 'click', function (event) {
	            $('.light_notice_backlayer').remove();
	            $(".frontlayer").remove();
	        });
	        $("body").delegate('.frontlayer', 'click', function (event) {
	            $('.light_notice_backlayer').remove();
	            $(".frontlayer").remove();
	        });
	        $("#mainContent").bind('keypress', function (event) {
	            if (event.ctrlKey && event.keyCode == "13") {
	                $('#send').trigger('click');
	            }
	        }).bind("click", function () {
	            if ($(".RongIMexpressionWrap").is(":visible")) $("#RongIMexpression").trigger('click');
	        });
	    };
	    self.showBigImg = function () {
	        var html = '<div class="light_notice_backlayer"></div>';
	        var frontLayer = '<div class="frontlayer"></div>';
	        var winWidth = $(window).width();
	        var winHeight = $(window).height();
	        var style = '';
	        var left = 0;
	        var top = 0;
	        var width = this.width;
	        if (width > winWidth) {
	            width = winWidth;
	        } else {
	            left = (winWidth - width) / 2;
	        }
	        if (this.height < winHeight) {
	            top = (winHeight - this.height) / 2;
	        }
	        //style = 'left: ' + left + 'px; top: ' + top + 'px';
	        this.obj.style.width = width + 'px';
	        $("body").append($(html));
	        var Layer = $(frontLayer);
	        //var obj = this.obj.outerHTML;
	        Layer.css('left', left + 'px');
	        Layer.css('top', top + 'px');

	        Layer.append(this.obj);
	        $("body").append(Layer);
	    };
	    self.showImg = function (cfg) {
	        var img = new Image();
	        img.src = cfg.img;
	        var callback = cfg.oncomplete;
	        img.onload = function () {
	            callback.call({ "width": img.width, "height": img.height, "obj": img }, null);
	        };
	    };
	    self.autoScroll = function () {
	        var scrollHeight = $('.dialog_box')[0].scrollHeight;
	        $('.dialog_box').scrollTop(scrollHeight);
	    };
	    self.drawExpressionWrap = function () {
	        var RongIMexpressionObj = $(".RongIMexpressionWrap");
	        if (win.RongIMClient) {
	            var arrImgList = RongIMClient.Expression.getAllExpression(60, 0);
	            if (arrImgList && arrImgList.length > 0) {
	                for (var objArr in arrImgList) {
	                    //扩展 Array prototype 使用for in问题
	                    var imgObj = arrImgList[objArr].img;
	                    if (!imgObj) {
	                        continue;
	                    }
	                    ;
	                    imgObj.setAttribute("alt", arrImgList[objArr].chineseName);
	                    imgObj.setAttribute("title", arrImgList[objArr].chineseName);
	                    //                    imgObj.alt = arrImgList[objArr].chineseName;
	                    var newSpan = $('<span class="RongIMexpression_' + arrImgList[objArr].englishName + '"></span>');
	                    newSpan.append(imgObj);
	                    RongIMexpressionObj.append(newSpan);
	                }
	            }
	            $(".RongIMexpressionWrap>span").bind('click', function (event) {
	                $(".textarea")[0].value += "[" + $(this).children().first().attr("alt") + "]";
	                //                $(".textarea").append($(this).clone());
	            });
	        }
	        ;
	    };
	    self.virtualKeyboardHeight = function () {
	        //var sx = $(window).scrollLeft(), sy = $(window).scrollTop();
	        //var naturalHeight = window.innerHeight;
	        //window.scrollTo(sx, document.body.scrollHeight);
	        //var keyboardHeight = naturalHeight - window.innerHeight;
	        //window.scrollTo(sx, sy);
	        //conf.keyboardHeight = keyboardHeight;
	        //return keyboardHeight;
	    };
	    self.getWinHeight = function (event) {
	        if (event && event.type == 'orientationchange') {
	            return conf.winWidth;
	        } else {
	            return $(window).height();
	        }
	    };
	    self.init = function () {
	        conf.winWidth = $(window).width();
	        conf.winHeight = $(window).height();
	        self.setBoxHeight();
	        self.bind();

	        self.drawExpressionWrap();

	        var newConf = conf.scroll;
	        newConf = lib.clone(newConf);
	        var listAddr = lib.clone(conf.scroll);
	        var newConf1 = lib.clone(conf.scroll);
	        $(".listConversation").niceScroll(conf.scroll);
	        $(".listAddr").niceScroll(listAddr);
	        $('.dialog_box').niceScroll(newConf);
	        $(".RongIMexpressionWrap").niceScroll(newConf1);
	        $(".conversation_msg_num").each(self.locateNum);
	        $(".status").each(self.locateMsgStatu);
	        self.autoScroll();
	        //不支持聲音
	        //if (typeof(conf.RongIMVoice) == 'boolean' && !conf.RongIMVoice) {
	        //    conf.RongIMVoice = RongIMClient.voice.init();
	        //}
	    };
	    win[conf.name] = self;
	})(window, document, window.jQuery);

	/**
	 * @function 全局初始化
	 */
	$().ready(function ($) {

	    $(document).delegate(".user_img img,.owner_image img", "error", function () {
	        this.setAttribute("src", "static/images/user.png");
	    });
	    if (window.RongCloudWebSDK) {
	        RongCloudWebSDK.init();
	    }
	    ;
	    function stopScrolling(touchEvent) {
	        touchEvent.preventDefault();
	    }

	    $("body").bind("touchmove", stopScrolling);
	    var docElm = document.documentElement;
	    if (docElm.requestFullscreen) {
	        docElm.requestFullscreen();
	    }
	    if (docElm.fullscreenEnabled) {
	        docElem.exitFullscreen();
	    }
	});

	/**
	 * 本代码中的SDK代码均为最新版0.9.9版本
	 * 修改本Demo的代码时注意SDK版本兼容性
	 * Author:张亚涛
	 * Date:2015-6-8
	 */

	$(function (undefined) {

	    //私有变量
	    var currentConversationTargetId = 0,
	        conver,
	        _historyMessagesCache = {},
	        token = "",
	        _html = "",
	        namelist = {
	        "group001": "融云群一",
	        "group002": "融云群二",
	        "group003": "融云群三",
	        "kefu114": "客服"
	    },
	        audio = document.getElementsByTagName("audio")[0],

	    //是否开启声音
	    hasSound = true,

	    //登陆人员信息默认值
	    owner = {
	        id: "",
	        portrait: "static/images/user_img.jpg",
	        name: "张亚涛"
	    },
	        $scope = {};
	    var conversationStr = '<li targetType="{0}" targetId="{1}" targetName="{2}"><span class="user_img"><img src={3} onerror="this.src=\'static/images/personPhoto.png\'"/><font class="conversation_msg_num {4}">{5}</font></span><span class="conversationInfo"><p style="margin-top: 10px"><font class="user_name">{6}</font><font class="date" >{7}</font></p></span></li>';
	    var historyStr = '<div class="xiaoxiti {0} user"><div class="user_img"><img onerror="this.src=\'static/images/personPhoto.png\'" src="{1}"/></div><span>{2}</span><div class="msg"><div class="msgArrow"><img src="static/images/{3}"> </div><span></span>{4}</div><div messageId="{5}" class="status"></div></div><div class="slice"></div>';

	    var friendListStr = '<li targetType="4" targetId="{0}" targetName="{1}"><span class="user_img"><img src="{2}"/></span> <span class="user_name">{1}</span></li>';

	    var discussionStr = '<li targetId="{0}" targetName="{1}" targetType="{2}"><span class="user_img"><img src="static/images/user.png"/></span><span class="user_name">{3}</span></li>';

	    //初始化请求地址
	    $scope.serverInfo = {};

	    $scope.serverInfo.prefix = "http://121.41.104.156:10086/";

	    /**
	     * @region 从外部获取到UserToken,鉴于是延迟操作，采用Promise方法
	     */

	    var dtd = $.Deferred(); //创建一个Dederred对象，用于进入联系人
	    var promise = dtd.promise();

	    //首先进行判断是否为WeChat环境
	    if ($.fn.browserUtils().isWechat()) {
	        //如果是微信环境，则进行自动登录
	        (0, _wechatJsx2["default"])();
	        dtd.resolve();
	    } else
	        //判断是否为Cordova环境
	        if ($.fn.browserUtils().isCordova()) {
	            //如果为Cordova环境，则调用Native接口获取用户数据
	            //Cordova环境下单人聊天，除了要获取用户列表，还要获取到目标用户id
	            document.addEventListener('deviceready', function () {

	                _pluginsJs.CordovaPlugin.init();

	                window.cordovaPlugins.getUserInfo().then(function (data) {

	                    window.localStorage.setItem("user_token", data.user_token);

	                    if (data.friend_id) {
	                        //如果存在朋友的目标的ID，则存入
	                        window.localStorage.setItem("friend_id", data.friend_id);
	                        window.localStorage.setItem("friend_name", data.friend_name);
	                        window.localStorage.setItem("friend_logo_img_path", data.friend_logo_img_path);
	                    } else {
	                        //清除上一次的本地的存值
	                        window.localStorage.removeItem("friend_id");
	                        window.localStorage.removeItem("friend_name");
	                    }

	                    dtd.resolve();
	                });
	            }, false);
	        } else {
	            dtd.resolve();
	        }

	    //获取到用户基本信息之后，像服务器请求用户信息
	    promise.then(function () {

	        //设置默认的用户的token
	        if (!window.localStorage.getItem("user_token")) {

	            window.localStorage.setItem("user_token", "cxq5nCZd4hlHApATmOgiapBt1igiCcw2FciIyTPHQOLU3D");

	            //判断URL中是否存在friend_id
	            window.localStorage.setItem("friend_id", "143218500373424379");

	            window.localStorage.setItem("friend_name", "我的好友");

	            window.localStorage.setItem("friend_logo_img_path", "");
	        }

	        //初始化登陆人员信息
	        $scope.userInfo = {};

	        $scope.userInfo.user_token = window.localStorage.getItem("user_token");

	        //调用后台接口获取个人信息
	        _modelJs.UserModel.getUserInfo($scope.userInfo.user_token).then(function (data) {

	            $.extend($scope.userInfo, data.userInfo);

	            //获取到了用户数据后，开始獲取好友列表
	            return _modelJs.UserModel.getUserFriends($scope.userInfo.user_token);
	        }).then(function (data) {

	            if (data.code == 0) {
	                _html = "";

	                //最多显示200个用户
	                $scope.friendsList = data.followingList.slice(0, 200);

	                //将自己添加到数组首位
	                $scope.friendsList.push({
	                    user_following_id: $scope.userInfo.user_id,
	                    user_nickname: $scope.userInfo.user_nickname ? $scope.userInfo.user_nickname : "我自己",
	                    user_logo_img_path: $scope.userInfo.user_logo_img_path ? $scope.userInfo.user_logo_img_path : 'static/images/user.png'
	                });

	                var isFriend = false;

	                $scope.friendsList.forEach(function (item) {
	                    if (item.user_following_id == window.localStorage.getItem("friend_id")) {
	                        isFriend = true;
	                    }
	                    _html += String.stringFormat(friendListStr, item.user_following_id, item.user_nickname, item.user_logo_img_path);
	                });

	                if (!isFriend) {
	                    _html += String.stringFormat(friendListStr, window.localStorage.getItem("friend_id"), window.localStorage.getItem("friend_name"), window.localStorage.getItem("friend_logo_img_path"));
	                }

	                $("#friendsList").html(_html);
	            }

	            //初始化SDK
	            RongIMClient.init("pgyu6atqykilu"); //e0x9wycfx7flq z3v5yqkbv8v30

	            //连接融云
	            RongIMClient.connect($scope.userInfo.rong_cloud_id, {

	                //获取成功，返回user_id
	                onSuccess: function onSuccess(x) {
	                    console.log("connected，userid＝" + x);

	                    //链接成功之后同步会话列表
	                    RongIMClient.getInstance().syncConversationList({
	                        onSuccess: function onSuccess() {
	                            //同步会话列表
	                            setTimeout(function () {
	                                $scope.ConversationList = RongIMClient.getInstance().getConversationList();
	                                var temp = null;
	                                for (var i = 0; i < $scope.ConversationList.length; i++) {
	                                    temp = $scope.ConversationList[i];
	                                    switch (temp.getConversationType()) {
	                                        case RongIMClient.ConversationType.CHATROOM:
	                                            temp.setConversationTitle('聊天室');
	                                            break;
	                                        case RongIMClient.ConversationType.CUSTOMER_SERVICE:
	                                            temp.setConversationTitle('客服');
	                                            break;
	                                        case RongIMClient.ConversationType.DISCUSSION:
	                                            temp.setConversationTitle('讨论组:' + temp.getTargetId());
	                                            break;
	                                        case RongIMClient.ConversationType.GROUP:
	                                            temp.setConversationTitle(namelist[temp.getTargetId()] || '未知群组');
	                                            break;
	                                        case RongIMClient.ConversationType.PRIVATE:
	                                            temp.getConversationTitle() || temp.setConversationTitle('陌生人:' + temp.getTargetId());
	                                    }
	                                }
	                                initConversationList();
	                                //判断是否需要进入单人聊天
	                                if (window.localStorage.getItem("friend_id")) {
	                                    $("#friendsList li[targetid=" + window.localStorage.getItem("friend_id") + "]").click();
	                                    //getHistory(window.localStorage.getItem("friend_id"), window.localStorage.getItem("friend_name"), RongIMClient.ConversationType.PRIVATE);
	                                    //$('.right_box').show;
	                                }
	                            }, 1000);
	                        }, onError: function onError() {
	                            $scope.ConversationList = RongIMClient.getInstance().getConversationList();
	                        }
	                    });
	                },
	                onError: function onError(c) {
	                    var info = '';
	                    switch (c) {
	                        case RongIMClient.callback.ErrorCode.TIMEOUT:
	                            info = '超时';
	                            break;
	                        case RongIMClient.callback.ErrorCode.UNKNOWN_ERROR:
	                            info = '未知错误';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.UNACCEPTABLE_PROTOCOL_VERSION:
	                            info = '不可接受的协议版本';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.IDENTIFIER_REJECTED:
	                            info = 'appkey不正确';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.SERVER_UNAVAILABLE:
	                            info = '服务器不可用';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.TOKEN_INCORRECT:
	                            info = 'token无效';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.NOT_AUTHORIZED:
	                            info = '未认证';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.REDIRECT:
	                            info = '重新获取导航';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.PACKAGE_ERROR:
	                            info = '包名错误';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.APP_BLOCK_OR_DELETE:
	                            info = '应用已被封禁或已被删除';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.BLOCK:
	                            info = '用户被封禁';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.TOKEN_EXPIRE:
	                            info = 'token已过期';
	                            break;
	                        case RongIMClient.ConnectErrorStatus.DEVICE_ERROR:
	                            info = '设备号错误';
	                            break;
	                    }
	                    console.log("失败:" + info);
	                }
	            });

	            //链接状态监听器
	            RongIMClient.setConnectionStatusListener({
	                onChanged: function onChanged(status) {
	                    switch (status) {
	                        //链接成功
	                        case RongIMClient.ConnectionStatus.CONNECTED:
	                            console.log('链接成功');
	                            break;
	                        //正在链接
	                        case RongIMClient.ConnectionStatus.CONNECTING:
	                            console.log('正在链接');
	                            break;
	                        //重新链接
	                        case RongIMClient.ConnectionStatus.RECONNECT:
	                            console.log('重新链接');
	                            break;
	                        //其他设备登陆
	                        case RongIMClient.ConnectionStatus.OTHER_DEVICE_LOGIN:
	                        //连接关闭
	                        case RongIMClient.ConnectionStatus.CLOSURE:
	                        //未知错误
	                        case RongIMClient.ConnectionStatus.UNKNOWN_ERROR:
	                        //登出
	                        case RongIMClient.ConnectionStatus.LOGOUT:
	                        //用户已被封禁
	                        case RongIMClient.ConnectionStatus.BLOCK:
	                            break;
	                    }
	                }
	            });

	            //接收消息监听器
	            RongIMClient.getInstance().setOnReceiveMessageListener({
	                onReceived: function onReceived(data) {
	                    if (hasSound) {
	                        audio.play();
	                    }
	                    //如果接收的消息为通知类型或者状态类型的消息，什么都不执行
	                    if (data instanceof RongIMClient.NotificationMessage || data instanceof RongIMClient.StatusMessage) {
	                        return;
	                    }

	                    $scope.totalunreadcount = RongIMClient.getInstance().getTotalUnreadCount();
	                    $("#totalunreadcount").show().html($scope.totalunreadcount);

	                    //设置会话名称
	                    var tempval = RongIMClient.getInstance().getConversation(data.getConversationType(), data.getTargetId());
	                    if (tempval.getConversationTitle() == undefined) {
	                        switch (data.getConversationType()) {
	                            case RongIMClient.ConversationType.CHATROOM:
	                                tempval.setConversationTitle('聊天室');
	                                break;
	                            case RongIMClient.ConversationType.CUSTOMER_SERVICE:
	                                tempval.setConversationTitle('客服');
	                                break;
	                            case RongIMClient.ConversationType.DISCUSSION:
	                                tempval.setConversationTitle('讨论组:' + data.getTargetId());
	                                break;
	                            case RongIMClient.ConversationType.GROUP:
	                                tempval.setConversationTitle(namelist[temp.getTargetId()] || '未知群组');
	                                break;
	                            case RongIMClient.ConversationType.PRIVATE:
	                                var person = $scope.friendsList.filter(function (item) {
	                                    return item.id == data.getTargetId();
	                                })[0];
	                                person ? tempval.setConversationTitle(person.username) : RongIMClient.getInstance().getUserInfo(data.getTargetId(), {
	                                    onSuccess: function onSuccess(x) {
	                                        tempval.setConversationTitle(x.getUserName());
	                                    },
	                                    onError: function onError() {
	                                        tempval.setConversationTitle("陌生人Id：" + data.getTargetId());
	                                    }
	                                });
	                                break;
	                            default:
	                                tempval.setConversationTitle('该会话类型未解析:' + data.getConversationType() + data.getTargetId());
	                                break;
	                        }
	                    }

	                    if (currentConversationTargetId != data.getTargetId()) {
	                        if (document.title != "[新消息]融云 Demo - Web SDK") document.title = "[新消息]融云 Demo - Web SDK";
	                        if (!_historyMessagesCache[data.getConversationType().valueOf() + "_" + data.getTargetId()]) _historyMessagesCache[data.getConversationType() + "_" + data.getTargetId()] = [data];else _historyMessagesCache[data.getConversationType().valueOf() + "_" + data.getTargetId()].push(data);
	                    } else {
	                        addHistoryMessages(data);
	                    }
	                    //加载会话列表
	                    initConversationList();
	                }
	            });
	        });
	    });

	    //未读消息数
	    $scope.totalunreadcount = 0;
	    //会话列表
	    $scope.ConversationList = [];
	    //好友列表
	    $scope.friendsList = [];
	    //会话标题
	    $scope.conversationTitle = "";

	    //开启关闭声音
	    $("#closeVoice").click(function () {
	        hasSound = !hasSound;
	        this.innerHTML = hasSound ? "开启声音" : "关闭声音";
	    });
	    //退出
	    $(".logOut>a,#close").click(function () {
	        //Todo Plugins 回退到上一个ViewController

	        window.cordovaPlugins.goBack();
	    });

	    /**
	     * @function 获取讨论组列表
	     */
	    //$.get("/discussion?_=" + Date.now(), function (data) {
	    //    if (data.code == 200) {
	    //        _html = "";
	    //        data.result.forEach(function (item) {
	    //            _html += String.stringFormat(discussionStr, item.id, item.name, RongIMClient.ConversationType.DISCUSSION.valueOf(), item.name);
	    //        });
	    //        $("#discussion").html(_html || "<li>没有加入任何讨论组</li>");
	    //    }
	    //});

	    //绑定到好友列表的点击事件
	    $("#friendsList,#conversationlist").delegate('li', 'touch click', function () {
	        if (this.parentNode.id == "conversationlist") {
	            $("font.conversation_msg_num", this).hide().html("");
	        }

	        getHistory(this.getAttribute("targetId"), this.getAttribute("targetName"), this.getAttribute("targetType"));
	    });
	    $("div.listAddr li:lt(4)").click(function () {
	        getHistory(this.getAttribute("targetId"), this.getAttribute("targetName"), this.getAttribute("targetType"));
	    });
	    var isJointed = false;
	    $("#discussionRoom").delegate('li', 'click', function () {
	        if (isJointed === false) {
	            RongIMClient.getInstance().joinChatRoom(this.getAttribute("targetId"), 10, {
	                onSuccess: function onSuccess() {
	                    $("#notice").show().css({ "color": "green" }).text("加入聊天室成功").delay(2000).fadeOut("slow");
	                    isJointed = true;
	                }, onError: function onError() {
	                    $("#notice").show().css({ "color": "green" }).text("加入聊天室失败").delay(2000).fadeOut("slow");
	                }
	            });
	        }
	        getHistory(this.getAttribute("targetId"), this.getAttribute("targetName"), this.getAttribute("targetType"));
	    });

	    /**
	     * @function 绑定发送文字的事件
	     */
	    $("#send").click(function () {
	        if (!conver && !currentConversationTargetId) {
	            alert("请选中需要聊天的人");
	            return;
	        }

	        var con = $("#mainContent").val().replace(/\[.+?\]/g, function (x) {
	            return RongIMClient.Expression.getEmojiObjByEnglishNameOrChineseName(x.slice(1, x.length - 1)).tag || x;
	        });
	        if (con == "") {
	            alert("不允许发送空内容");
	            return;
	        }
	        if (RongIMClient.getInstance().getConversation(RongIMClient.ConversationType.setValue(conver), currentConversationTargetId) === null) {
	            RongIMClient.getInstance().createConversation(RongIMClient.ConversationType.setValue(conver), currentConversationTargetId, $("#conversationTitle").text());
	        }
	        //发送消息
	        var content = new RongIMClient.MessageContent(RongIMClient.TextMessage.obtain(myUtil.replaceSymbol(con)));
	        RongIMClient.getInstance().sendMessage(RongIMClient.ConversationType.setValue(conver), currentConversationTargetId, content, null, {
	            onSuccess: function onSuccess() {
	                console.log("send successfully");
	            },
	            onError: function onError(x) {
	                var info = '';
	                switch (x) {
	                    case RongIMClient.callback.ErrorCode.TIMEOUT:
	                        info = '超时';
	                        break;
	                    case RongIMClient.callback.ErrorCode.UNKNOWN_ERROR:
	                        info = '未知错误';
	                        break;
	                    case RongIMClient.SendErrorStatus.REJECTED_BY_BLACKLIST:
	                        info = '在黑名单中，无法向对方发送消息';
	                        break;
	                    case RongIMClient.SendErrorStatus.NOT_IN_DISCUSSION:
	                        info = '不在讨论组中';
	                        break;
	                    case RongIMClient.SendErrorStatus.NOT_IN_GROUP:
	                        info = '不在群组中';
	                        break;
	                    case RongIMClient.SendErrorStatus.NOT_IN_CHATROOM:
	                        info = '不在聊天室中';
	                        break;
	                    default:
	                        info = x;
	                        break;
	                }
	                $(".dialog_box div[messageId='" + content.getMessage().getMessageId() + "']").addClass("status_error");
	                console.log('发送失败:' + info);
	            }
	        });
	        addHistoryMessages(content.getMessage());
	        initConversationList();
	        $("#mainContent").val("");
	    });

	    //渲染历史记录
	    function addHistoryMessages(item) {
	        $scope.historyMessages.push(item);
	        $(".dialog_box:first").append(String.stringFormat(historyStr, item.getMessageDirection() == RongIMClient.MessageDirection.RECEIVE ? "other_user" : "self", item.getMessageDirection() == RongIMClient.MessageDirection.SEND ? owner.portrait : "static/images/personPhoto.png", "", item.getMessageDirection() == RongIMClient.MessageDirection.RECEIVE ? 'white_arrow.png' : 'blue_arrow.png', myUtil.msgType(item), item.getMessageId()));
	    }

	    //加载会话列表
	    function initConversationList() {
	        _html = "";
	        $scope.ConversationList.forEach(function (item) {
	            _html += String.stringFormat(conversationStr, item.getConversationType().valueOf(), item.getTargetId(), item.getConversationTitle(), "static/images/personPhoto.png", item.getUnreadMessageCount() == 0 ? "hidden" : "", item.getUnreadMessageCount(), item.getConversationTitle(), new Date(+item.getLatestTime()).toString().split(" ")[4]);
	        });
	        $("#conversationlist").html(_html);
	    }

	    //加载历史记录
	    function getHistory(id, name, type, again) {
	        if (!window.Modules) //检测websdk是否已经加载完毕
	            return;
	        conver = type;
	        currentConversationTargetId = id;
	        if (!_historyMessagesCache[type + "_" + currentConversationTargetId]) _historyMessagesCache[type + "_" + currentConversationTargetId] = [];
	        $scope.historyMessages = _historyMessagesCache[type + "_" + currentConversationTargetId];

	        if ($scope.historyMessages.length == 0 && !again) {
	            RongIMClient.getInstance().getHistoryMessages(RongIMClient.ConversationType.setValue(conver), currentConversationTargetId, 5, {
	                onSuccess: function onSuccess(has, list) {
	                    console.log("是否有剩余消息：" + has);
	                    _historyMessagesCache[type + "_" + currentConversationTargetId] = list;
	                    getHistory(currentConversationTargetId, name, conver, 1);
	                }, onError: function onError(error) {
	                    console.log('获取历史消息失败');
	                    getHistory(currentConversationTargetId, name, conver, 1);
	                }
	            });
	            return;
	        }
	        $scope.conversationTitle = name;
	        var tempval = RongIMClient.getInstance().getConversation(RongIMClient.ConversationType.setValue(conver), currentConversationTargetId);
	        $("#conversationTitle").next().remove();
	        if (type == RongIMClient.ConversationType.CHATROOM) {
	            //聊天室
	            $("#conversationTitle").after('<span class="setDialog"></span>');
	        }
	        $("#conversationTitle").html($scope.conversationTitle);
	        _html = "";
	        $scope.historyMessages.forEach(function (item) {
	            _html += String.stringFormat(historyStr, item.getMessageDirection() == 0 ? "other_user" : "self", item.getMessageDirection() == 1 ? owner.portrait : "static/images/personPhoto.png", "", item.getMessageDirection() == 0 ? 'white_arrow.png' : 'blue_arrow.png', myUtil.msgType(item), item.getMessageId());
	        });
	        if (again == 1 && _html) {
	            _html += "<div class='historySymbol'>已上为历史消息</div>";
	        }
	        $(".dialog_box:first").html(_html);
	        if (tempval === null) {
	            return;
	        }
	        tempval.setUnreadMessageCount(0);
	        RongIMClient.getInstance().clearMessagesUnreadStatus(RongIMClient.ConversationType.setValue(type), currentConversationTargetId);
	        $scope.totalunreadcount = RongIMClient.getInstance().getTotalUnreadCount();
	        if ($scope.totalunreadcount <= 0 && /^\[新消息\]/.test(document.title)) {
	            document.title = "融云 Demo - Web SDK";
	        }
	        $("#totalunreadcount").html($scope.totalunreadcount);
	        if ($scope.totalunreadcount == 0) {
	            $("#totalunreadcount").hide();
	        }
	    }
	});

	String.stringFormat = function (str) {
	    for (var i = 1; i < arguments.length; i++) {
	        str = str.replace(new RegExp("\\{" + (i - 1) + "\\}", "g"), arguments[i] != undefined ? arguments[i] : "");
	    }
	    return str;
	};
	var myUtil = {
	    msgType: function msgType(message) {
	        switch (message.getMessageType()) {
	            case RongIMClient.MessageType.TextMessage:
	                return String.stringFormat('<div class="msgBody">{0}</div>', this.initEmotion(this.symbolReplace(message.getContent())));
	            case RongIMClient.MessageType.ImageMessage:
	                return String.stringFormat('<div class="msgBody">{0}</div>', "<img class='imgThumbnail' src='data:image/jpg;base64," + message.getContent() + "' bigUrl='" + message.getImageUri() + "'/>");
	            case RongIMClient.MessageType.VoiceMessage:
	                return String.stringFormat('<div class="msgBody voice">{0}</div><input type="hidden" value="' + message.getContent() + '">', "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + message.getDuration());
	            case RongIMClient.MessageType.LocationMessage:
	                return String.stringFormat('<div class="msgBody">{0}</div>{1}', "[位置消息]" + message.getPoi(), "<img src='data:image/png;base64," + message.getContent() + "'/>");
	            default:
	                return '<div class="msgBody">' + message.getMessageType().toString() + ':此消息类型Demo未解析</div>';
	        }
	    },
	    initEmotion: function initEmotion(str) {
	        var a = document.createElement("span");
	        return RongIMClient.Expression.retrievalEmoji(str, function (img) {
	            a.appendChild(img.img);
	            var str = '<span class="RongIMexpression_' + img.englishName + '">' + a.innerHTML + '</span>';
	            a.innerHTML = "";
	            return str;
	        });
	    },
	    symbolReplace: function symbolReplace(str) {
	        if (!str) return '';
	        str = str.replace(/&/g, '&amp;');
	        str = str.replace(/</g, '&lt;');
	        str = str.replace(/>/g, '&gt;');
	        str = str.replace(/"/g, '&quot;');
	        str = str.replace(/'/g, '&#039;');
	        return str;
	    },
	    replaceSymbol: function replaceSymbol(str) {
	        if (!str) return '';
	        str = str.replace(/&amp;/g, '&');
	        str = str.replace(/&lt;/g, '<');
	        str = str.replace(/&gt;/g, '>');
	        str = str.replace(/&quot;/g, '"');
	        str = str.replace(/&#039;/g, "'");
	        str = str.replace(/&nbsp;/g, " ");
	        return str;
	    }
	};

/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Created by apple on 15/8/18.
	 */
	'use strict';

	Object.defineProperty(exports, '__esModule', {
	    value: true
	});
	$ = __webpack_require__(2);

	/**
	 * @function 静态文件加载
	 **/
	$.extend({

	    /**
	     * @function 动态加载JS文件
	     * @param sid script tag id
	     * @param jsurl
	     * @param callback 回调函数
	     * */
	    loadJs: function loadJs(sid, jsurl, callback) {
	        var nodeHead = document.getElementsByTagName('head')[0];
	        var nodeScript = null;
	        if (document.getElementById(sid) == null) {
	            nodeScript = document.createElement('script');
	            nodeScript.setAttribute('type', 'text/javascript');
	            nodeScript.setAttribute('src', jsurl);
	            nodeScript.setAttribute('id', sid);
	            if (callback != null) {
	                nodeScript.onload = nodeScript.onreadystatechange = function () {
	                    if (nodeScript.ready) {
	                        return false;
	                    }
	                    if (!nodeScript.readyState || nodeScript.readyState == "loaded" || nodeScript.readyState == 'complete') {
	                        nodeScript.ready = true;
	                        callback();
	                    }
	                };
	            }
	            nodeHead.appendChild(nodeScript);
	        } else {
	            if (callback != null) {
	                callback();
	            }
	        }
	    },
	    /**
	     * @function 解析url
	     * @param url
	     * @returns {{source: *, protocol: string, host: (boolean|string), port: (*|Function|string), query: (*|string|Document.search|Symbol|string), params, file: *, hash: (void|string|*|XML), path: string, relative: *, segments: Array}}
	     */
	    parseUrl: function parseUrl(url) {
	        var a = document.createElement('a');
	        a.href = url;
	        return {
	            source: url,
	            protocol: a.protocol.replace(':', ''),
	            host: a.hostname,
	            port: a.port,
	            query: a.search,
	            params: (function () {
	                var ret = {},
	                    seg = a.search.replace(/^\?/, '').split('&'),
	                    len = seg.length,
	                    i = 0,
	                    s;
	                for (; i < len; i++) {
	                    if (!seg[i]) {
	                        continue;
	                    }
	                    s = seg[i].split('=');
	                    ret[s[0]] = s[1];
	                }
	                return ret;
	            })(),
	            file: (a.pathname.match(/\/([^\/?#]+)$/i) || [, ''])[1],
	            hash: a.hash.replace('#', ''),
	            path: a.pathname.replace(/^([^\/])/, '/$1'),
	            relative: (a.href.match(/tps?:\/\/[^\/]+(.+)/) || [, ''])[1],
	            segments: a.pathname.replace(/^\//, '').split('/')
	        };
	    },

	    /**
	     * @function 全局配置文件
	     */
	    globalConfig: {}

	});

	$.fn.browserUtils = function () {

	    var ua = navigator.userAgent.toLowerCase();

	    return {
	        /**
	         *@function 判斷是不是微信瀏覽器
	         */
	        isWechat: function isWechat() {

	            if (ua.match(/MicroMessenger/i) == "micromessenger") {
	                return true;
	            } else {
	                return false;
	            }
	        },
	        /**
	         * @function 判断是否是Cordova运行环境
	         */
	        isCordova: function isCordova() {

	            if (typeof cordova === 'undefined') {
	                return false;
	            } else {
	                return true;
	            }
	        }
	    };
	};

	$.fn.wechatUtils = function () {
	    return {
	        /**
	         * 判斷是否登錄並且完成自動登錄
	         */
	        autoLogin: function autoLogin() {

	            /**
	             * 用戶完成了微信登錄之後的回調頁面
	             */
	            if ($("#last_url").val()) {

	                //存放user_token
	                window.localStorage.setItem("user_token", $("#user_token").val());

	                //存放wechat用户信息
	                //         openid
	                window.localStorage.setItem("wechat_user_info_openid", $("#wechat_user_info_openid").val());

	                //         nickname
	                window.localStorage.setItem("wechat_user_info_nickname", $("#wechat_user_info_nickname").val());

	                //         sex
	                window.localStorage.setItem("wechat_user_info_sex", $("#wechat_user_info_sex").val());

	                //         language
	                window.localStorage.setItem("wechat_user_info_language", $("#wechat_user_info_language").val());

	                //         city
	                window.localStorage.setItem("wechat_user_info_city", $("#wechat_user_info_city").val());

	                //         province
	                window.localStorage.setItem("wechat_user_info_province", $("#wechat_user_info_province").val());

	                //         country
	                window.localStorage.setItem("wechat_user_info_country", $("#wechat_user_info_country").val());

	                //         headimgurl
	                window.localStorage.setItem("wechat_user_info_headimgurl", $("#wechat_user_info_headimgurl").val());

	                //         unionid
	                window.localStorage.setItem("wechat_user_info_unionid", $("#wechat_user_info_unionid").val());

	                //存放签名信息
	                window.localStorage.setItem("jssdk_signature_timestamp", $("#jssdk_signature_timestamp").val());

	                window.localStorage.setItem("jssdk_signature_nonceStr", $("#jssdk_signature_nonceStr").val());

	                window.localStorage.setItem("jssdk_signature_signature", $("#jssdk_signature_signature").val());

	                //判断当前的跳转域名是否在当前域名下
	                if ($.parseUrl($("#last_url").val()).host != location.hostname) {
	                    //如果不是在同一个域名下，则带参数跳转
	                    location.href = $("#last_url").val() + "?user_token=" + $("#user_token").val();
	                } else {
	                    location.href = $("#last_url").val();
	                }
	            }

	            //获取当前路径
	            var current_href = location.href;

	            //判断当前用户是否登陆过
	            var user_token = window.localStorage.getItem("user_token");

	            //判断是否是在URL中包含了user_token
	            if (current_href.indexOf("user_token") > 0) {

	                //如果已经包含了user_token，则提取出user_token

	                var url_dict = $.parseUrl(current_href);

	                user_token = url_dict.params['user_token'];
	            }

	            if (user_token && user_token != "") {

	                //如果用户已经登录，则不进行任何操作
	                window.localStorage.setItem("user_token", user_token);
	            } else {

	                //否则跳转到微信授权页面
	                location.href = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx023fb614ea7d282c&" + "redirect_uri=http%3a%2f%2fm.live-forest.com%2findex.php%2fHome%2fWechatMP%2fgetUserInfo&" + "response_type=code&" + "scope=snsapi_userinfo&" + "state=" + current_href;
	            }
	        },
	        /**
	         * @function 配置JSSDK
	         */
	        sdkConfig: function sdkConfig() {

	            //加载需要的JS文件
	            $.loadJs("tarsocial", "http://tarsocial.oss-cn-hangzhou.aliyuncs.com/tarsocial-monitor-v1002.js", function () {

	                $.loadJs("jssdk", "http://res.wx.qq.com/open/js/jweixin-1.0.0.js", function () {

	                    /**
	                     * @function 获取存储的微信的信息
	                     */
	                    var wechat_user_info = {};

	                    tar.config({
	                        tar_token: "rCMl44J4EqGq0PvPNi9hcQsKX9E8%2Ba4", //必填，监测系统分配给此次监测活动的token
	                        tar_tid: "100102" }, //必填，监测系统分配给此次监测活动的id
	                    [{
	                        //         openid
	                        openid: window.localStorage.getItem("wechat_user_info_openid"),
	                        //         nickname
	                        nickname: window.localStorage.getItem("wechat_user_info_nickname"),
	                        //         sex
	                        sex: window.localStorage.getItem("wechat_user_info_sex"),
	                        //         language
	                        language: window.localStorage.getItem("wechat_user_info_language"),
	                        //         city
	                        city: window.localStorage.getItem("wechat_user_info_city"),
	                        //         province
	                        province: window.localStorage.getItem("wechat_user_info_province"),
	                        //         country
	                        country: window.localStorage.getItem("wechat_user_info_country"),
	                        //         headimgurl
	                        headimgurl: window.localStorage.getItem("wechat_user_info_headimgurl"),
	                        //         unionid
	                        unionid: window.localStorage.getItem("wechat_user_info_unionid")
	                    }] //userinfo为微信用户授权接口返回的JSON数据包; 网页如接入微信授权此项必填，未接入则传空。
	                    );

	                    wx.config({
	                        debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
	                        appId: "wx023fb614ea7d282c", //必填,公众号的唯一标识
	                        timestamp: window.localStorage.getItem("jssdk_signature_timestamp"), //必填,生成签名的时间戳
	                        nonceStr: window.localStorage.getItem("jssdk_signature_nonceStr"), //必填,生成签名的随机串
	                        signature: window.localStorage.getItem("jssdk_signature_signature"), //必填,签名,见 http://t.cn/RL24Fgw
	                        jsApiList: ["onMenuShareTimeline", "onMenuShareAppMessage", //如业务需求，可继续加入其他微信JS接口
	                        "chooseImage"]
	                    });

	                    /**
	                     * @function 注册失败的回调
	                     */
	                    wx.error(function (res) {

	                        // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
	                        //alert(res);

	                    });

	                    /**
	                     * @function 微信驗證之後的回調方法
	                     */
	                    wx.ready(function () {

	                        var shareData64 = {
	                            title: "", //必填,分享标题
	                            desc: "", //选填,分享描述
	                            imgUrl: "", //选填,分享图片
	                            link: "http://m.live-forest.com/index.php/Home/Yueban/getYuebanDetail", //必填,可跟get参数,禁止直接使用location.href
	                            success: function success() {
	                                // 用户确认分享后执行的回调函数

	                            },
	                            cancel: function cancel() {
	                                // 用户取消分享后执行的回调函数
	                            }
	                        };
	                        wx.onMenuShareAppMessage(tar.shapeShareAppMessage(shareData64));
	                        wx.onMenuShareTimeline(tar.shapeShareTimeline(shareData64));
	                    });
	                });
	            });
	        }
	    };
	};
	var wechatConfig = function wechatConfig() {
	    if ($.fn.browserUtils().isWechat()) {
	        //如果是微信，自动进行跳转
	        $.fn.wechatUtils().autoLogin();
	    }
	};

	//默认导出
	exports['default'] = wechatConfig;
	module.exports = exports['default'];

/***/ },
/* 2 */
/***/ function(module, exports) {

	module.exports = jQuery;

/***/ },
/* 3 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Created by apple on 15/8/25.
	 */
	/**
	 *@function 数据模型层
	 **/

	/**
	 *@region 引用接口
	 */
	'use strict';

	Object.defineProperty(exports, '__esModule', {
	    value: true
	});

	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

	var $ = __webpack_require__(2);

	var serverInfo = {
	    prefix: "http://121.41.104.156:10086/"
	};

	var UserModel = (function () {
	    function UserModel() {
	        _classCallCheck(this, UserModel);
	    }

	    /**
	     * @region 导出接口
	     */

	    _createClass(UserModel, null, [{
	        key: 'getUserInfo',

	        /**
	         * @function 获取用户基本信息
	         * @param user_token
	         * @return Promise对象
	         */
	        value: function getUserInfo(user_token, callback) {

	            //构造一个新的Defered对象
	            var dtd = $.Deferred();

	            // This only is an example to create asynchronism
	            $.getJSON(serverInfo.prefix + 'User/Person/getPersonInfo?requestData={"user_token":"' + user_token + '"}&callback=?', function (data) {
	                //数据获取完毕后执行对象
	                dtd.resolve(data);
	            });

	            return dtd.promise();
	        }

	        /**
	         * @function 获取用户的好友列表
	         * @param user_token
	         */
	    }, {
	        key: 'getUserFriends',
	        value: function getUserFriends(user_token, callback) {

	            //构造一个新的Defered对象
	            var dtd = $.Deferred();

	            $.getJSON(serverInfo.prefix + 'Social/Following/getFollowingList?requestData={"user_token":"' + user_token + '"}&callback=?', function (data) {
	                dtd.resolve(data);
	            });
	            return dtd.promise();
	        }
	    }]);

	    return UserModel;
	})();

	exports.UserModel = UserModel;

/***/ },
/* 4 */
/***/ function(module, exports, __webpack_require__) {

	/**
	 * Created by apple on 15/8/26.
	 */
	/**
	 *@function Cordova Plugins
	 **/
	'use strict';

	Object.defineProperty(exports, '__esModule', {
	    value: true
	});

	var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

	var $ = __webpack_require__(2);

	var CordovaPlugin = (function () {
	    function CordovaPlugin() {
	        _classCallCheck(this, CordovaPlugin);
	    }

	    _createClass(CordovaPlugin, null, [{
	        key: 'init',
	        value: function init() {

	            //注册获取用户信息的插件
	            window.cordovaPlugins = {};

	            window.cordovaPlugins.getUserInfo = function () {

	                //构造一个新的Defered对象
	                var dtd = $.Deferred();

	                //只需要在这里监听下deviceReady
	                document.addEventListener('deviceready', function () {

	                    console.log('Device is Ready!');

	                    cordova.exec(function (data) {
	                        dtd.resolve(data);
	                    }, function (err) {
	                        dtd.reject(err);
	                    }, "UserInfoPlugin", "getUserInfo", []);
	                }, false);

	                return dtd.promise();
	            };

	            window.cordovaPlugins.goBack = function () {

	                //构造一个新的Defered对象
	                var dtd = $.Deferred();

	                cordova.exec(function (data) {
	                    resolve(data);
	                }, function (err) {
	                    reject(err);
	                }, "UserInfoPlugin", "goBack", []);
	                return dtd.promise();
	            };
	        }
	    }]);

	    return CordovaPlugin;
	})();

	exports.CordovaPlugin = CordovaPlugin;

/***/ }
/******/ ]);