# CCSLoader介绍与使用


### CCSLoader是什么

ccsloader是quick在V3版本上提供的一个解析ccs studio的UI布局,场景导出json文件的工具

它会解析json文件,并用quick中自带的纯lua控件(cc.ui中的控件)来展示对应的布局或场景


### quick-V2.X上是否支持CCSLoader

ccsloader是在首先在V3上编写,在quick-V2.2.5发布后才移植到V2上的,quick-V2.2.5后的版本都具有CCSLoader功能


### CCSLoader的用法


json文件的解析与显示

```lua
--传入要解析的json文件
local node = cc.uiloader:load("/res/test.ExportJson")
--解析成功后，会返回UI树的根结点，把它加到场景中
if node then
    node:setPosition(0, 0)
    scene:addChild(node)
end
```

从解析后的UI布局按名字查找结点

``` lua
--布局中有一个名字为"DragPanel"滚动控件
local scrollView = cc.uiloader:seekNodeByName(node, "DragPanel")
--在scrollView上注册滚动回调事件,它的用法,API接口在cc.ui.UIScrollView
scrollView:onScroll(function(event)
		print("CCSSample3Scene scroll")
	end)
```

从解析后的场景按名字顺序查找组件

``` lua
-- "hero" 是结点名称
-- 1 是 "hero"这个结点下的第一个组件
local hero = cc.uiloader:seekComponents(node, "hero", 1)
--hero是一个Armature,找到后，播放攻击动作
hero:getAnimation():play("attack")
```


更多用法参见样例samples/ccsloader
