#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <cstrike>

#define PLUGIN_NAME    "Custom Weapons Shop"
#define PLUGIN_VERSION "1.0"
#define PLUGIN_AUTHOR  "sakulmore"

new Trie:g_tWeaponNames;
new Trie:g_tWeaponAmmo;
new Array:g_aMenuItems;

enum _:ItemData {
    Item_Wep1[32],
    Item_Wep2[32],
    Item_Wep3[32],
    Item_Sound[64],
    Item_Flag,
    Item_VipText[32]
}

new g_szNamesCfg[256];
new g_szWeaponsCfg[256];
new g_szAmmoCfg[256];

public plugin_precache()
{
    new datadir[128];
    get_datadir(datadir, charsmax(datadir));
    
    formatex(g_szNamesCfg, charsmax(g_szNamesCfg), "%s/weaponnames.cfg", datadir);
    formatex(g_szWeaponsCfg, charsmax(g_szWeaponsCfg), "%s/custom_weapons.cfg", datadir);
    formatex(g_szAmmoCfg, charsmax(g_szAmmoCfg), "%s/custom_weapons_ammo.cfg", datadir);

    g_tWeaponNames = TrieCreate();
    g_tWeaponAmmo = TrieCreate();
    g_aMenuItems = ArrayCreate(ItemData);

    EnsureConfigsExist();
    LoadWeaponNames();
    LoadWeaponAmmo();
    LoadCustomWeapons();
}

public plugin_init()
{
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);

    register_clcmd("say /cws", "CmdShowMenu");
    register_clcmd("say /customweapons", "CmdShowMenu");
}

public plugin_end()
{
    TrieDestroy(g_tWeaponNames);
    TrieDestroy(g_tWeaponAmmo);
    ArrayDestroy(g_aMenuItems);
}

EnsureConfigsExist()
{
    if (!file_exists(g_szNamesCfg))
    {
        new fp = fopen(g_szNamesCfg, "wt");
        if (fp)
        {
            fprintf(fp, "; You can customize the names of weapons to suit your preferences.%c", 10);
            fprintf(fp, "weapon_p228 = P228%c", 10);
            fprintf(fp, "weapon_shield = Shield%c", 10);
            fprintf(fp, "weapon_scout = Scout%c", 10);
            fprintf(fp, "weapon_hegrenade = HE%c", 10);
            fprintf(fp, "weapon_xm1014 = XM1014%c", 10);
            fprintf(fp, "weapon_c4 = C4%c", 10);
            fprintf(fp, "weapon_mac10 = MAC10%c", 10);
            fprintf(fp, "weapon_aug = Aug%c", 10);
            fprintf(fp, "weapon_smokegrenade = SMOKE%c", 10);
            fprintf(fp, "weapon_elite = Dual Beretta%c", 10);
            fprintf(fp, "weapon_fiveseven = Five Seven%c", 10);
            fprintf(fp, "weapon_ump45 = UMP45%c", 10);
            fprintf(fp, "weapon_sg550 = SG-550%c", 10);
            fprintf(fp, "weapon_galil = Galil%c", 10);
            fprintf(fp, "weapon_famas = Famas%c", 10);
            fprintf(fp, "weapon_usp = USP%c", 10);
            fprintf(fp, "weapon_glock18 = Glock18%c", 10);
            fprintf(fp, "weapon_awp = AWP%c", 10);
            fprintf(fp, "weapon_mp5navy = MP5%c", 10);
            fprintf(fp, "weapon_m249 = M249%c", 10);
            fprintf(fp, "weapon_m3 = M3%c", 10);
            fprintf(fp, "weapon_m4a1 = M4A1%c", 10);
            fprintf(fp, "weapon_tmp = TMP%c", 10);
            fprintf(fp, "weapon_g3sg1 = G3/SG-1%c", 10);
            fprintf(fp, "weapon_flashbang = Flashbang%c", 10);
            fprintf(fp, "weapon_deagle = Desert Eagle%c", 10);
            fprintf(fp, "weapon_sg552 = Sig 552%c", 10);
            fprintf(fp, "weapon_ak47 = AK-47%c", 10);
            fprintf(fp, "weapon_p90 = P-90%c", 10);
            fclose(fp);
        }
    }

    if (!file_exists(g_szWeaponsCfg))
    {
        new fp = fopen(g_szWeaponsCfg, "wt");
        if (fp)
        {
            fprintf(fp, "; Custom Weapons Config File%c", 10);
            fprintf(fp, "; Example:%c", 10);
            fprintf(fp, ";%c", 10);
            fprintf(fp, "; %c<weapon1>%c %c<weapon2>%c %c<weapon3>%c %c<sound>%c %c<admin_flag>%c %c<vip_text>%c%c", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 10);
            fprintf(fp, ";%c", 10);
            fprintf(fp, "; The value %cnone%c can be used for: %cweapon2%c, %cweapon3%c, %csound%c, %cadmin_flag%c, %cvip_text%c%c", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 10);
            
            fprintf(fp, "%cweapon_m4a1%c %cweapon_deagle%c %cweapon_hegrenade%c %cnone%c %cnone%c %cnone%c%c", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 10);
            fprintf(fp, "%cweapon_awp%c %cweapon_deagle%c %cnone%c %cnone%c %ct%c %cVIP%c%c", 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 10);
            
            fclose(fp);
        }
    }

    if (!file_exists(g_szAmmoCfg))
    {
        new fp = fopen(g_szAmmoCfg, "wt");
        if (fp)
        {
            fprintf(fp, "; You can customize the backpack ammo for given weapons.%c", 10);
            fprintf(fp, "weapon_p228 = 250%c", 10);
            fprintf(fp, "weapon_shield = 250%c", 10);
            fprintf(fp, "weapon_scout = 250%c", 10);
            fprintf(fp, "weapon_hegrenade = 5%c", 10);
            fprintf(fp, "weapon_xm1014 = 250%c", 10);
            fprintf(fp, "weapon_mac10 = 250%c", 10);
            fprintf(fp, "weapon_aug = 250%c", 10);
            fprintf(fp, "weapon_smokegrenade = 250%c", 10);
            fprintf(fp, "weapon_elite = 250%c", 10);
            fprintf(fp, "weapon_fiveseven = 250%c", 10);
            fprintf(fp, "weapon_ump45 = 250%c", 10);
            fprintf(fp, "weapon_sg550 = 250%c", 10);
            fprintf(fp, "weapon_galil = 250%c", 10);
            fprintf(fp, "weapon_famas = 250%c", 10);
            fprintf(fp, "weapon_usp = 250%c", 10);
            fprintf(fp, "weapon_glock18 = 250%c", 10);
            fprintf(fp, "weapon_awp = 250%c", 10);
            fprintf(fp, "weapon_mp5navy = 250%c", 10);
            fprintf(fp, "weapon_m249 = 250%c", 10);
            fprintf(fp, "weapon_m3 = 250%c", 10);
            fprintf(fp, "weapon_m4a1 = 250%c", 10);
            fprintf(fp, "weapon_tmp = 250%c", 10);
            fprintf(fp, "weapon_g3sg1 = 250%c", 10);
            fprintf(fp, "weapon_flashbang = 5%c", 10);
            fprintf(fp, "weapon_deagle = 250%c", 10);
            fprintf(fp, "weapon_sg552 = 250%c", 10);
            fprintf(fp, "weapon_ak47 = 250%c", 10);
            fprintf(fp, "weapon_p90 = 250%c", 10);
            fclose(fp);
        }
    }
}

LoadWeaponNames()
{
    new fp = fopen(g_szNamesCfg, "rt");
    if (!fp) return;

    new szLine[128], szKey[64], szVal[64];
    while (!feof(fp))
    {
        fgets(fp, szLine, charsmax(szLine));
        trim(szLine);

        if (!szLine[0] || szLine[0] == ';') continue;

        if (strtok(szLine, szKey, charsmax(szKey), szVal, charsmax(szVal), '='))
        {
            trim(szKey);
            trim(szVal);
            TrieSetString(g_tWeaponNames, szKey, szVal);
        }
    }
    fclose(fp);
}

LoadWeaponAmmo()
{
    new fp = fopen(g_szAmmoCfg, "rt");
    if (!fp) return;

    new szLine[128], szKey[64], szVal[64];
    while (!feof(fp))
    {
        fgets(fp, szLine, charsmax(szLine));
        trim(szLine);

        if (!szLine[0] || szLine[0] == ';') continue;

        if (strtok(szLine, szKey, charsmax(szKey), szVal, charsmax(szVal), '='))
        {
            trim(szKey);
            trim(szVal);
            TrieSetCell(g_tWeaponAmmo, szKey, str_to_num(szVal));
        }
    }
    fclose(fp);
}

LoadCustomWeapons()
{
    new fp = fopen(g_szWeaponsCfg, "rt");
    if (!fp) return;

    new szLine[256];
    new szWep1[32], szWep2[32], szWep3[32], szSound[64], szFlag[32], szVip[32];
    new itemData[ItemData];

    while (!feof(fp))
    {
        fgets(fp, szLine, charsmax(szLine));
        trim(szLine);

        if (!szLine[0] || szLine[0] == ';') continue;

        szWep1[0] = '^0'; szWep2[0] = '^0'; szWep3[0] = '^0'; 
        szSound[0] = '^0'; szFlag[0] = '^0'; szVip[0] = '^0';

        parse(szLine, 
            szWep1, charsmax(szWep1), 
            szWep2, charsmax(szWep2), 
            szWep3, charsmax(szWep3), 
            szSound, charsmax(szSound), 
            szFlag, charsmax(szFlag), 
            szVip, charsmax(szVip));

        if (!szWep1[0] || equali(szWep1, "none")) continue;

        copy(itemData[Item_Wep1], charsmax(itemData[Item_Wep1]), szWep1);
        
        copy(itemData[Item_Wep2], charsmax(itemData[Item_Wep2]), equali(szWep2, "none") ? "" : szWep2);
        copy(itemData[Item_Wep3], charsmax(itemData[Item_Wep3]), equali(szWep3, "none") ? "" : szWep3);

        if (!equali(szSound, "none") && szSound[0])
        {
            new szFullPath[128];
            formatex(szFullPath, charsmax(szFullPath), "sound/customweapons/%s", szSound);
            
            if (file_exists(szFullPath))
            {
                copy(itemData[Item_Sound], charsmax(itemData[Item_Sound]), szSound);
                
                new szPrecache[128];
                formatex(szPrecache, charsmax(szPrecache), "customweapons/%s", szSound);
                precache_sound(szPrecache);
            }
            else
            {
                itemData[Item_Sound][0] = '^0';
            }
        }
        else
        {
            itemData[Item_Sound][0] = '^0';
        }

        if (equali(szFlag, "none") || !szFlag[0])
        {
            itemData[Item_Flag] = 0;
        }
        else
        {
            itemData[Item_Flag] = read_flags(szFlag);
        }

        if (!equali(szVip, "none") && szVip[0])
        {
            copy(itemData[Item_VipText], charsmax(itemData[Item_VipText]), szVip);
        }
        else
        {
            itemData[Item_VipText][0] = '^0';
        }

        ArrayPushArray(g_aMenuItems, itemData);
    }
    fclose(fp);
}

GetWeaponDisplayName(const szWeapon[], szOutput[], maxLen)
{
    if (!TrieGetString(g_tWeaponNames, szWeapon, szOutput, maxLen))
    {
        copy(szOutput, maxLen, szWeapon);
    }
}

ApplyWeaponAmmo(id, const szWeapon[])
{
    if (equali(szWeapon, "weapon_c4")) return;

    new ammoAmount;
    if (TrieGetCell(g_tWeaponAmmo, szWeapon, ammoAmount))
    {
        new wepId = get_weaponid(szWeapon);
        if (wepId > 0)
        {
            cs_set_user_bpammo(id, wepId, ammoAmount);
        }
    }
}

public CmdShowMenu(id)
{
    if (!is_user_alive(id))
    {
        client_print(id, print_chat, "[Custom Weapons Shop] You must be alive to use this.");
        return PLUGIN_HANDLED;
    }

    new count = ArraySize(g_aMenuItems);
    if (count == 0)
    {
        client_print(id, print_chat, "[Custom Weapons Shop] There are no custom weapons available right now.");
        return PLUGIN_HANDLED;
    }

    new menu = menu_create("\yCustom Weapons Shop", "Menu_Handler");
    new itemData[ItemData];
    new szDisplay[128], szName[64];

    for (new i = 0; i < count; i++)
    {
        ArrayGetArray(g_aMenuItems, i, itemData);
        
        szDisplay[0] = '^0';

        GetWeaponDisplayName(itemData[Item_Wep1], szName, charsmax(szName));
        copy(szDisplay, charsmax(szDisplay), szName);

        if (itemData[Item_Wep2][0])
        {
            GetWeaponDisplayName(itemData[Item_Wep2], szName, charsmax(szName));
            format(szDisplay, charsmax(szDisplay), "%s + %s", szDisplay, szName);
        }

        if (itemData[Item_Wep3][0])
        {
            GetWeaponDisplayName(itemData[Item_Wep3], szName, charsmax(szName));
            format(szDisplay, charsmax(szDisplay), "%s + %s", szDisplay, szName);
        }

        if (itemData[Item_Flag] != 0 && itemData[Item_VipText][0])
        {
            format(szDisplay, charsmax(szDisplay), "%s \y[%s]\w", szDisplay, itemData[Item_VipText]);
        }

        new szNum[8];
        num_to_str(i, szNum, charsmax(szNum));

        if (itemData[Item_Flag] == 0 || (get_user_flags(id) & itemData[Item_Flag]))
        {
            menu_additem(menu, szDisplay, szNum);
        }
        else
        {
            new szDisabled[128];
            formatex(szDisabled, charsmax(szDisabled), "\d%s", szDisplay);
            menu_additem(menu, szDisabled, szNum, ADMIN_ADMIN);
        }
    }

    menu_display(id, menu, 0);
    return PLUGIN_HANDLED;
}

public Menu_Handler(id, menu, item)
{
    if (item == MENU_EXIT || !is_user_alive(id))
    {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }

    new data[8], szName[64], access, callback;
    menu_item_getinfo(menu, item, access, data, charsmax(data), szName, charsmax(szName), callback);
    
    new index = str_to_num(data);
    new itemData[ItemData];
    ArrayGetArray(g_aMenuItems, index, itemData);
    menu_destroy(menu);

    if (itemData[Item_Flag] != 0 && !(get_user_flags(id) & itemData[Item_Flag]))
    {
        client_print(id, print_chat, "[Custom Weapons Shop] You do not have access to this item.");
        return PLUGIN_HANDLED;
    }

    strip_user_weapons(id);
    give_item(id, "weapon_knife");

    new szReceivedText[128], szWepName[64];

    if (itemData[Item_Wep1][0])
    {
        give_item(id, itemData[Item_Wep1]);
        ApplyWeaponAmmo(id, itemData[Item_Wep1]);
        
        GetWeaponDisplayName(itemData[Item_Wep1], szWepName, charsmax(szWepName));
        copy(szReceivedText, charsmax(szReceivedText), szWepName);
    }
    
    if (itemData[Item_Wep2][0])
    {
        give_item(id, itemData[Item_Wep2]);
        ApplyWeaponAmmo(id, itemData[Item_Wep2]);
        
        GetWeaponDisplayName(itemData[Item_Wep2], szWepName, charsmax(szWepName));
        format(szReceivedText, charsmax(szReceivedText), "%s, %s", szReceivedText, szWepName);
    }
    
    if (itemData[Item_Wep3][0])
    {
        give_item(id, itemData[Item_Wep3]);
        ApplyWeaponAmmo(id, itemData[Item_Wep3]);
        
        GetWeaponDisplayName(itemData[Item_Wep3], szWepName, charsmax(szWepName));
        format(szReceivedText, charsmax(szReceivedText), "%s, %s", szReceivedText, szWepName);
    }

    if (itemData[Item_Sound][0])
    {
        client_cmd(id, "spk ^"customweapons/%s^"", itemData[Item_Sound]);
    }

    client_print(id, print_chat, "[Custom Weapons Shop] You have received: %s.", szReceivedText);

    return PLUGIN_HANDLED;
}