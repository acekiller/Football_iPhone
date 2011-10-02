
var eventPanel;
var statPanel;

new Ext.Application({

//Ext.regApplication({
    
    name: 'app',

    launch: function() {

        var event = [{ minutes:15, eventText:'进球', type:1 }, { minutes:20, eventText:'黄牌', type:2 }];

        var stat = [{ awayTotal:15, statName:'射门次数', homeTotal:22},
                    { awayTotal:3, statName:'犯规次数', homeTotal:4}];

        var helperFunctions = {
            isScoreEvent : function(type){
                return (type == 1); // 是否是进球
            },

            isCardEvent : function(type){
                return (type == 2); // 是否是红黄牌
            }
        };

        var eventInfo = Ext.XTemplate.from("event-template", helperFunctions);

        var statInfo = new Ext.XTemplate(
            '<h2>统计数据</h2>',
            '<tpl for=".">',
                '<div>{homeTotal} {statName} {awayTotal}</div>',
            '</tpl>'
        );

        eventPanel = new Ext.Panel({
            
            id : 'eventPanel',
            scroll : 'vertical',
            tpl : eventInfo,

            margin: '20 10 20 0',
            align: 'left',
        });

        statPanel = new Ext.Panel({
            id : 'statPanel',
            tpl : statInfo
        });


        this.viewport = new Ext.Panel({

            fullscreen: true,
            id: 'matchDetailPanel',
            layout: {
                type: 'vbox',
                align: 'stretch',
            },
            items: [eventPanel, statPanel],
            

        });

        eventPanel.update(event);
        statPanel.update(stat);

//        console.log('launch');
    }

});

function updateMatchDetail(data){
	eventPanel.update(data.event);
	statPanel.update(data.stat);	
}
