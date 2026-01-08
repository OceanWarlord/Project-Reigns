randomize();

global.event_history = ds_list_create();
global.max_history = 6;
global.forced_next_event = -1;

// ---------- NPCs STRUCTURE ----------
global.npcs = {
    alfred:      { name: "Alfred", role: "treasurer", base_loyalty: 40, is_alive: true, enabled: true },
    barnaby:     { name: "Barnaby", role: "treasurer", base_loyalty: 50, is_alive: true, enabled: false },
    kaedric:     { name: "Kaedric Thorne", role: "general", base_loyalty: 78, is_alive: true, enabled: true },
    eldric:      { name: "Eldric Varn", role: "chancellor", base_loyalty: 70, is_alive: true, enabled: true },
    malvena:     { name: "Malvena", role: "bishop", base_loyalty: 61, is_alive: true, enabled: true },
    elara:       { name: "Elara", role: "advisor", base_loyalty: 100, is_alive: true, enabled: true },

    garran:      { name: "Sir Garran", role: "knight", base_loyalty: 40, is_alive: true, enabled: true },
    virellian:   { name: "Virellian Shade", role: "spymaster", base_loyalty: 58, is_alive: true, enabled: true },
    tharos:      { name: "Tharos Flint", role: "builder", base_loyalty: 72, is_alive: true, enabled: true },
    bertha:      { name: "Bertha Mourn", role: "warden", base_loyalty: 47, is_alive: true, enabled: true },
    elys:        { name: "Lady Elys Viremont", role: "envoy", base_loyalty: 63, is_alive: true, enabled: true },
    arthen:      { name: "Arthen Hal", role: "historian", base_loyalty: 55, is_alive: true, enabled: true },
    
	alvan:       { name: "Brother Alvan", role: "steward", base_loyalty: 60, is_alive: true, enabled: true },
    jorek:       { name: "Commander Jorek", role: "warden_east", base_loyalty: 75, is_alive: true, enabled: true },
    calia:       { name: "Calia Raventhorn", role: "scoutmaster", base_loyalty: 50, is_alive: true, enabled: true },
    rurik:       { name: "Rurik Stonejaw", role: "overseer", base_loyalty: 59, is_alive: true, enabled: true },
    lysara:      { name: "Queen Lysara", role: "queen", base_loyalty: 65, is_alive: true, enabled: true },
    aeloria:     { name: "Princess Aeloria", role: "family", base_loyalty: 65, is_alive: true, enabled: true },
    
	mirene:      { name: "Princess Mirene", role: "family", base_loyalty: 65, is_alive: true, enabled: true },
    sylvara:     { name: "Princess Sylvara", role: "family", base_loyalty: 65, is_alive: true, enabled: true },
    thalion:     { name: "Prince Thalion", role: "family", base_loyalty: 65, is_alive: true, enabled: true },
    veyran:      { name: "Lord Veyran", role: "family", base_loyalty: 45, is_alive: true, enabled: true },
    kael:        { name: "Kael Draven", role: "bastard", base_loyalty: 30, is_alive: true, enabled: false },
    idris:       { name: "Profeta Idris", role: "prophet", base_loyalty: 35, is_alive: true, enabled: true },
    
	veylith:     { name: "Sereth Veylith", role: "noble", base_loyalty: 50, is_alive: true, enabled: true },
	ironfist:    { name: "Rei Tharok Ironfist", role: "enemy", base_loyalty: 20, is_alive: true, enabled: true },
    lirien:      { name: "Alta Matriarca Lirien", role: "leader_eldmere", base_loyalty: 40, is_alive: true, enabled: true },
    syltharion:  { name: "Syltharion", role: "emissary", base_loyalty: 55, is_alive: true, enabled: true },
    erynn:       { name: "Erynn Shadowcloak", role: "seer", base_loyalty: 50, is_alive: true, enabled: false }
};

// ---------- UTILITY ----------

function get_npc_by_role(_role) {
    var _names = struct_get_names(global.npcs);
    for (var i = 0; i < array_length(_names); i++) {
        var _n = global.npcs[$ _names[i]];
        if (_n.role == _role && _n.enabled && _n.is_alive) return _names[i];
    }
    return undefined;
}

function role_is_active(_role) {
    return (get_npc_by_role(_role) != undefined);
}

// ---------- EVENT BUILDER ----------
function GameEvent(_id, _text, _npc, _options, _numtopick) constructor {
    event_id      = _id;
    event_text    = _text;
    npc_key       = _npc;
    options       = _options;
	num_to_pick   = _numtopick
    
    req_role      = argument_count > 5 ? argument[5] : undefined;
    is_chain_only = argument_count > 6 ? argument[6] : false;
    is_once       = argument_count > 7 ? argument[7] : false;
    req_npc       = argument_count > 8 ? argument[8] : undefined;
    min_choices   = argument_count > 9 ? argument[9] : 2;
    max_choices   = argument_count > 10 ? argument[10] : 3;
}

global.event_pool = [
    // ---------- 999+ UTILITY EVENTS ----------
    
    new GameEvent(1000, "Redirecting...", "lysara", [], 0, "treasurer", true, false, undefined, 0, 0),
	new GameEvent(999, "O reino colapsou sob o peso de suas escolhas. Sem pilares para sustentá-lo, a coroa cai na lama e o silêncio reina nos corredores do palácio. Seu tempo acabou.", "lysara", [], 0, undefined, true, false, undefined, 0, 0),

	// ---------- GAME EVENTS ----------
	
    new GameEvent(1, "The troops are hungry and demanding higher pay. Their morale is dropping.", "kaedric", [
        { text: "Pay them", gold: [-25, -15], army: [10, 20], loyalty_impact: { kaedric: 10 } },
        { text: "Refuse", gold: [0, 0], army: [-30, -20], loyalty_impact: { kaedric: -20 } },
        { text: "Ration food", gold: [0, 0], army: [-15, -5], people: [-15, -5], loyalty_impact: { kaedric: -5 } },
        { text: "Consult Treasurer", is_mandatory: true, req_role: "treasurer", force_event: 1000 },
        { text: "Let them loot", gold: [5, 15], army: [1, 10], people: [-40, -20], loyalty_impact: { kaedric: 5 } }
    ], 3, undefined, false, false, undefined, 2, 3),
	
    new GameEvent(2, "Sire, our coffers can handle the pay, but the Bishop will surely notice.", "alfred", [
        { text: "Pay all", gold: [-50, -35], army: [20, 30], church: [-15, -5], loyalty_impact: { alfred: 10, malvena: -10 } },
        { text: "Half pay", gold: [-15, -5], army: [1, 10], loyalty_impact: { alfred: 5 } },
        { text: "Borrow Gold", gold: [40, 60], family: [-25, -15], loyalty_impact: { alfred: -10 } },
        { text: "Cancel", force_event: 1 }
    ], 3, "treasurer", true, false, "alfred", 2, 3),

    new GameEvent(3, "Sire, we should use the emergency grain store. It is a safer bet.", "barnaby", [
        { text: "Use Grain", gold: -10, people: -10, army: 15, loyalty_impact: { barnaby: 15 } },
        { text: "Cancel", force_event: 1 }
    ], 2, "treasurer", true, false, "barnaby", 2, 2),

    new GameEvent(4, "A priest is accused of heresy. The Church demands a trial immediately.", "malvena", [
        { text: "Allow trial", church: [15, 25], people: [-15, -5], loyalty_impact: { malvena: 10 } },
        { text: "Pardon him", church: [-25, -15], people: [5, 15], loyalty_impact: { malvena: -15 } },
        { text: "Bribe Bishop", gold: [-40, -20], church: [5, 15], loyalty_impact: { malvena: 5 }, req_role: "treasurer" },
        { text: "Silence Accuser", army: [-10, -1], church: [-10, -1], people: [-10, -1] }
    ], 2, "bishop", false, false, undefined, 2, 2),

    new GameEvent(5, "The Bishop is auditing the books. Alfred seems very nervous.", "malvena", [
        { text: "Support Alfred", gold: -10, loyalty_impact: { alfred: 15, malvena: -15 } },
        { text: "Allow Audit", gold: 0, church: 15, force_event: 6, loyalty_impact: { malvena: 10, alfred: -20 } }
    ], 2, "bishop", false, false, "alfred", 2, 2),

    new GameEvent(6, "Evidence of Alfred's corruption. Should we exile him?", "malvena", [
        { text: "Exile Alfred", gold: 20, church: 10, lock_npc: "alfred", kill_npc: "alfred", loyalty_impact: { malvena: 15 } },
        { text: "Protect him", gold: -10, loyalty_impact: { alfred: 20, malvena: -20 } },
        { text: "Imprison him", gold: 0, army: 5, lock_npc: "alfred", kill_npc: "alfred", loyalty_impact: { malvena: 10 } }
    ], 2, "bishop", true, false, "alfred", 2, 3),

    new GameEvent(7, "The accounting is a mess. We need a professional to manage our gold.", "lysara", [
        { text: "Hire Alfred", gold: -10, family: 5, unlock_npc: "alfred", req_npc: "alfred" }, 
        { text: "Hire Barnaby", gold: -10, family: 5, unlock_npc: "barnaby", req_npc: "barnaby" },
        { text: "I'll do it", gold: -15, family: -10 }
    ], 2, undefined, false, true, undefined, 2, 2),

    new GameEvent(8, "A plague spreads in the slums. The city is in a state of panic.", "eldric", [
        { text: "Send Medics", gold: [-20, -10], people: [15, 30] },
        { text: "Quarantine", army: [1, 10], people: [-30, -10] },
        { text: "Pray", church: [10, 20], people: [-10, 0] },
        { text: "Burn District", gold: [5, 15], people: [-60, -40], army: [-15, -5] }
    ], 3, undefined, false, false, undefined, 2, 3),

    new GameEvent(9, "The merchants want to lower taxes to increase trade in the region.", "eldric", [
        { text: "Agree", gold: -10, people: 15, loyalty_impact: { eldric: 15 } },
        { text: "Refuse", gold: 25, people: -15, loyalty_impact: { eldric: -10 } },
        { text: "Compromise", gold: 0, people: 5, loyalty_impact: { eldric: 5 } }
    ], 3, "treasurer", false, false, undefined, 2, 3),

    new GameEvent(10, "A mysterious figure offers information about a traitor in your court.", "eldric", [
        { text: "Pay Gold", gold: -20, force_event: 11 },
        { text: "Ignore", gold: 0, people: -5 }
    ], 2, undefined, false, false, undefined, 2, 2),

    new GameEvent(11, "The traitor was an officer. What is the verdict, Sire?", "kaedric", [
        { text: "Execution", army: -5, people: 15, loyalty_impact: { kaedric: -10 } },
        { text: "Exile", gold: 10, family: 10, loyalty_impact: { lysara: 5 } },
        { text: "Pardon", army: 15, people: -10, loyalty_impact: { kaedric: 15 } }
    ], 3, undefined, true, false, undefined, 2, 3),

    new GameEvent(12, "Your cousin expects a grand gift for his upcoming wedding.", "lysara", [
        { text: "Royal Gold", gold: [-60, -40], family: [25, 40], loyalty_impact: { lysara: 15 } },
        { text: "Modest Gift", gold: [-10, -2], family: [1, 10], loyalty_impact: { lysara: -5 } },
        { text: "Gift Land", people: [-20, -10], family: [10, 20] },
        { text: "Ignore", family: [-25, -15], gold: [5, 15] }
    ], 2, "queen", false, false, undefined, 2, 3),

    new GameEvent(13, "General Thorne wants to seize Church lands to build a new fort.", "kaedric", [
        { text: "Seize land", army: 20, church: -30, loyalty_impact: { kaedric: 15, malvena: -25 } },
        { text: "Protect Church", army: -10, church: 15, loyalty_impact: { malvena: 10, kaedric: -10 } },
        { text: "Buy the land", gold: -40, army: 10, church: 5 }
    ], 3, "general", false, false, undefined, 2, 3),
	
    new GameEvent(14, "Sir, I found a secret gold stash. How should we allocate it?", "eldric", [
        { text: "For Swords", gold: 0, army: 30, loyalty_impact: { eldric: -10 } },
        { text: "Keep it", gold: 40, loyalty_impact: { eldric: 20 } },
        { text: "Give to People", gold: 0, people: 30 }
    ], 3, "treasurer", false, false, undefined, 2, 3),

    new GameEvent(15, "Queen Lysara suggests organizing a grand royal feast...", "lysara", [
        { text: "Organize with kingdom resources.", gold: [-50, -30], supplies: [-40, -20], people: [30, 50], family: [20, 40] },
        { text: "Ask the nobles to fund the feast.", gold: [10, 30], people: [20, 40], family: [20, 40] },
        { text: "Decline the idea.", family: [-40, -20] },
        { text: "Host a modest feast.", supplies: [-30, -10], people: [15, 25], family: [15, 25] },
        { text: "Involve the clergy.", gold: [-40, -20], church: [20, 40], family: [10, 30] },
        { text: "Military parade.", supplies: [-40, -20], army: [20, 40], family: [-30, -10] }
    ], 3, "queen", false, false, undefined, 2, 3),

    new GameEvent(16, "Princess Aeloria wishes to train with the High Marshal...", "aeloria", [
        { text: "Allow the training.", army: 30, family: 30, force_event: 17 },
        { text: "Forbid it, it is too dangerous.", family: -30 },
        { text: "Suggest she studies diplomacy.", people: 20, family: -10 },
        { text: "Assign a royal guard to oversee.", gold: -20, army: 20, family: 20 },
        { text: "Encourage her to inspire troops.", people: 30, family: 20 },
        { text: "Ignore her request.", family: -20 }
    ], 3, "family", false, true, "aeloria", 2, 3),

    new GameEvent(17, "Princess Aeloria has completed her training and suggests an expedition...", "aeloria", [
        { text: "Support expedition.", army: -40, supplies: -30, people: 40, family: 30, force_event: 18 },
        { text: "Decline, too risky.", family: -30 },
        { text: "Small scouting party.", army: -20, family: 10 },
        { text: "Ask her to train others.", army: 20, family: 20 },
        { text: "Publicly praise her.", people: 30, family: 20 },
        { text: "Ignore suggestion.", family: -20 }
    ], 3, "family", true, false, "aeloria", 2, 3),

    new GameEvent(18, "Aeloria's expedition was a success, but she found an enemy camp...", "aeloria", [
        { text: "Allow her to lead.", army: -50, people: 60, family: 40 },
        { text: "Send army without her.", army: -40, family: -30 },
        { text: "Ignore the camp.", people: -40, family: -30 },
        { text: "Negotiate with enemy.", gold: -30, people: 20 },
        { text: "Fortify defenses.", supplies: -30, army: 30 },
        { text: "Send spies to monitor.", gold: -20, family: 10 }
    ], 3, "family", true, false, "aeloria", 2, 3),

    new GameEvent(19, "Princess Mirene wants to study with the kingdom's sages...", "mirene", [
        { text: "Invest in her education.", gold: -40, family: 30, force_event: 20 },
        { text: "No resources for this now.", family: -30 },
        { text: "Send her to study agriculture.", gold: -30, supplies: 30, family: 20 },
        { text: "Encourage self-study.", family: 10 },
        { text: "Involve priests in education.", gold: -20, church: 20, family: 20 },
        { text: "Prioritize her social duties.", people: 20, family: -20 }
    ], 3, "family", false, true, "mirene", 2, 3),

    new GameEvent(20, "Princess Mirene has finished her studies and proposes a project...", "mirene", [
        { text: "Support the project.", gold: -50, supplies: 60, family: 30 },
        { text: "Decline project.", family: -30 },
        { text: "Fund pilot project.", gold: -30, supplies: 30, family: 20 },
        { text: "Share ideas with farmers.", people: 20, family: 20 },
        { text: "Involve nobles.", gold: 20, family: 10 },
        { text: "Ignore proposal.", family: -20 }
    ], 3, "family", true, false, "mirene", 2, 3),

    new GameEvent(21, "Princess Sylvara is lonely and asks for a playmate...", "sylvara", [
        { text: "Hire a playmate for her.", gold: -20, family: 30 },
        { text: "Tell her to play alone.", family: -30 },
        { text: "Join village children.", people: 20, family: 20 },
        { text: "Assign a family member.", family: 20 },
        { text: "Gift her educational toys.", gold: -10, family: 10 },
        { text: "Dismiss her request.", family: -20 }
    ], 3, "family", false, false, "sylvara", 2, 3),

    new GameEvent(22, "Prince Thalion has a fever. Queen Lysara is worried...", "lysara", [
        { text: "Call the best healers.", gold: [-60, -40], family: [30, 50], church: [20, 40] },
        { text: "Let it pass naturally.", family: [-50, -30], church: [-40, -20] },
        { text: "Consult herbalists.", supplies: [-30, -10], family: [15, 25] },
        { text: "Pray for recovery.", church: [15, 30], family: [5, 15] },
        { text: "Foreign physicians.", gold: [-50, -30], family: [25, 35] }
    ], 3, "queen", false, false, "lysara", 2, 3),

    new GameEvent(23, "Lord Veyran has publicly claimed the throne...", "veyran", [
        { text: "Challenge in a public trial.", people: 30, family: -30, force_event: 24 },
        { text: "Exile Lord Veyran.", family: -50, people: 20, loyalty_impact: { veyran: -10 } },
        { text: "Negotiate a compromise.", gold: -40, family: 20, loyalty_impact: { veyran: 5 } },
        { text: "Imprison and seize assets.", gold: 30, family: -40, people: -20, loyalty_impact: { veyran: -15 } },
        { text: "Publicly denounce him.", people: 20, family: -30, loyalty_impact: { veyran: -8 } },
        { text: "Seek Church's support.", church: 30, family: -20 }
    ], 3, "family", false, true, "veyran", 2, 3),

    new GameEvent(24, "The trial of Lord Veyran has begun. What is your verdict?", "eldric", [
        { text: "Guilty and Exile.", people: 40, family: -40, loyalty_impact: { veyran: -15 } },
        { text: "Pardon, strip titles.", family: 20, people: -20, loyalty_impact: { veyran: -5 } },
        { text: "Imprison him.", people: 30, family: -30, loyalty_impact: { veyran: -10 } },
        { text: "Execute him.", people: 20, family: -50, loyalty_impact: { veyran: -20 } },
        { text: "Banish supporters.", people: -10, family: 10, loyalty_impact: { veyran: 5 } },
        { text: "Religious ruling.", church: 20, people: -10 }
    ], 3, "chancellor", true, false, "veyran", 2, 3),

    new GameEvent(25, "A young man named Kael Draven claims to be the bastard son...", "lysara", [
        { text: "Acknowledge Kael.", family: -40, people: 30, unlock_npc: "kael", loyalty_impact: { lysara: -5 } },
        { text: "Deny and banish him.", family: 20, people: -30, force_event: 27 },
        { text: "Investigate discreetly.", gold: -20, family: -10, force_event: 26 },
        { text: "Imprison Kael.", family: -20, people: -20, loyalty_impact: { kael: -10 } },
        { text: "Consult the Church.", church: 20, family: -10 },
        { text: "Bribe Kael to leave.", gold: -30, family: 10, people: -10 }
    ], 3, "queen", false, true, undefined, 2, 3),

    new GameEvent(26, "Spies confirm Kael Draven is Alaric III's son...", "virellian", [
        { text: "Legitimize Kael.", family: -50, people: 40, unlock_npc: "kael", loyalty_impact: { lysara: -10 } },
        { text: "Banish him.", family: 30, people: -30, force_event: 27 },
        { text: "Support discreetly.", gold: -30, family: -20, unlock_npc: "kael" },
        { text: "Imprison him.", family: -30, people: -20, loyalty_impact: { kael: -15 } },
        { text: "Offer lands for silence.", gold: -40, family: 10 },
        { text: "Consult the Church.", church: 20, family: -20 }
    ], 3, "spymaster", true, false, undefined, 2, 3),

    new GameEvent(27, "Kael Draven has allied with House Veylith and is raising a force...", "kael", [
        { text: "Crush rebellion.", army: -50, people: -30 },
        { text: "Negotiate return.", gold: -40, family: 30, unlock_npc: "kael" },
        { text: "Assassinate him.", gold: -30, people: -40 },
        { text: "Isolate him.", gold: -20, people: 20, loyalty_impact: { veylith: -5 } },
        { text: "Fortify capital.", supplies: -30, army: 20 },
        { text: "Church denouncement.", church: 20, people: -10 }
    ], 3, undefined, true, false, "kael", 2, 3),

    new GameEvent(28, "A plague has started spreading in the outer villages...", "bertha", [
        { text: "Send medical supplies.", supplies: -40, force_event: 29 },
        { text: "Isolate the village.", people: -30, force_event: 29 },
        { text: "Consult priests.", church: 20, people: -10, force_event: 29 },
        { text: "Distribute food.", supplies: -20, people: 10, force_event: 29 }
    ], 3, undefined, false, true, undefined, 2, 3),

    new GameEvent(29, "The plague is worsening. Healers request more resources...", "bertha", [
        { text: "Provide resources.", gold: -50, supplies: -40, force_event: 30 },
        { text: "Keep village isolated.", people: -40, force_event: 30 },
        { text: "Send limited supplies.", supplies: -20, people: -10, force_event: 30 },
        { text: "Religious rituals.", church: 30, people: -20, force_event: 30 },
        { text: "Evacuate healthy ones.", gold: -30, people: 10, force_event: 30 },
        { text: "Do nothing.", people: -30, force_event: 30 }
    ], 3, undefined, true, false, undefined, 2, 3),

    new GameEvent(30, "The plague has reached a critical point...", "malvena", [
        { text: "Burn the village.", people: -80, supplies: -40 },
        { text: "Invest everything.", gold: -60, supplies: -60, people: 60 },
        { text: "Minimal aid.", supplies: -30, people: -20 },
        { text: "Appeal to allies.", gold: -40, people: 20 },
        { text: "Relocate royal court.", people: -30, family: -20 },
        { text: "Rely on faith.", church: 40, people: -30 }
    ], 3, "bishop", true, false, undefined, 2, 3),

    new GameEvent(31, "Scouts report a skirmish on the northern border...", "kaedric", [
        { text: "Send troops to repel.", army: -40, people: 30 },
        { text: "Fortify the border.", supplies: -30, army: 20 },
        { text: "Request aid from Eldmere.", people: 10, force_event: 33 }, 
        { text: "Ignore the skirmish.", people: -30, army: -20 }
    ], 3, "general", false, false, undefined, 2, 3),

    new GameEvent(32, "King Tharok Ironfist of Yronvall demands tribute...", "ironfist", [
        { text: "Pay the tribute.", gold: [-70, -50], people: [-50, -30], force_event: 1000 },
        { text: "Prepare for war.", army: [40, 60], people: [20, 40] },
        { text: "Seek Eldmere alliance.", people: [15, 25], force_event: 33 },
        { text: "Undermine forces.", gold: [-40, -20], army: [15, 25] },
        { text: "Publicly denounce.", people: [30, 50], army: [15, 25], gold: [-30, -10] }
    ], 3, undefined, false, false, "ironfist", 2, 3),

    new GameEvent(33, "Matriarch Lirien of Eldmere offers an alliance...", "lirien", [
        { text: "Accept marriage alliance.", army: 40, family: -30, force_event: 34, loyalty_impact: { aeloria: -15 } },
        { text: "Decline and stay neutral.", family: 20, army: -20 },
        { text: "Propose trade instead.", gold: -30, supplies: 30 },
        { text: "Demand support only.", army: 20, people: -20, loyalty_impact: { lirien: -5 } },
        { text: "Investigate intentions.", gold: -20, army: 10 },
        { text: "Offer different royal.", family: -20, people: 10, loyalty_impact: { aeloria: 10 } }
    ], 3, undefined, false, false, "lirien", 2, 3),

    new GameEvent(34, "Syltharion requests a joint expedition to recover the sacred Orb...", "syltharion", [
        { text: "Agree to expedition.", army: -40, church: 30, force_event: 35 },
        { text: "Decline.", army: -20, church: -20 },
        { text: "Small delegation.", gold: -20, church: 10 },
        { text: "Demand relic as payment.", church: -30, people: -20, loyalty_impact: { syltharion: -10 } },
        { text: "Steal the relic.", gold: -30, church: -40, people: -30 },
        { text: "Trade agreement.", gold: -20, supplies: 20, people: 10 }
    ], 3, undefined, true, false, "syltharion", 2, 3),

    new GameEvent(35, "Seer Erynn reveals Alaric III's dark pact...", "erynn", [
        { text: "Support the search.", gold: -50, church: 40, force_event: 36 },
        { text: "Refuse.", church: -30, army: -20 },
        { text: "Church handles it.", church: 20, people: -20 },
        { text: "Investigate Shadow.", gold: -30, people: -10 },
        { text: "Dwarven artifact.", gold: -40, army: 20, unlock_npc: "drenkar" },
        { text: "Isolate areas.", people: -30, supplies: -20 }
    ], 3, undefined, true, false, "erynn", 2, 3),

    new GameEvent(36, "The Orb is found, but the Shadow demands a sacrifice...", "erynn", [
        { text: "Sacrifice royal relic.", church: 50, family: -30 },
        { text: "Destroy the Orb.", church: -40, people: -30 },
        { text: "Sacrifice a village.", people: -80, church: 30 },
        { text: "Banish with force.", army: -50, church: -30, people: -20 }
    ], 3, undefined, true, true, "erynn", 2, 3),

    new GameEvent(37, "The villagers are planning a local festival to celebrate the harvest...", "elys", [
        { text: "Give your blessing.", people: 30 },
        { text: "Ignore the request.", gold: 0 },
        { text: "Fund it generously.", gold: -30, people: 50 },
        { text: "Send priests to bless.", church: 20, people: 20 },
        { text: "Attend in person.", people: 40, family: 10 },
        { text: "Prohibit the festival.", people: -30 }
    ], 3, "envoy", false, false, undefined, 2, 3),

    new GameEvent(38, "A traveling bard has arrived and offers to entertain the court...", "arthen", [
        { text: "Allow him to perform.", force_event: 39 },
        { text: "Send him away.", people: -30 },
        { text: "Private dinner.", gold: -10, people: 20 },
        { text: "Royal propaganda.", gold: -10, people: 30 },
        { text: "Gift him supplies.", supplies: -10, people: 10 },
        { text: "Ignore his arrival.", people: -10 }
    ], 3, "historian", false, false, undefined, 2, 3),

    new GameEvent(39, "The bard enchanted everyone. He now asks to stay...", "arthen", [
        { text: "Accept as official.", gold: -20, people: 40 },
        { text: "Thank but decline.", people: -30 },
        { text: "Festivals only.", gold: -10, people: 20 },
        { text: "Train local bards.", gold: -20, people: 30 },
        { text: "Send to allies.", people: 10 },
        { text: "Ignore request.", people: -10 }
    ], 3, "historian", true, false, undefined, 2, 3),

    new GameEvent(40, "Bishop Tharion suggests a religious festival to appease the gods.", "malvena", [
        { text: "Support festival.", gold: -30, supplies: -20, church: 40, people: 30, unlock_npc: "yselda" },
        { text: "Decline, too costly.", church: -30, people: -30 },
        { text: "Small prayer ceremony.", gold: -10, church: 20 },
        { text: "Involve military.", supplies: -20, army: 20, church: 20 },
        { text: "Nobles fund it.", gold: 20, church: 30 },
        { text: "Prohibit gatherings.", church: -40, people: -20 }
    ], 3, "bishop", false, false, "malvena", 2, 3),

    new GameEvent(41, "Queen Lysara and Princess Aeloria had a public argument...", "lysara", [
        { text: "Mediate personally.", family: 30, loyalty_impact: { lysara: 3, aeloria: 3 } },
        { text: "Ignore it.", family: -30, loyalty_impact: { lysara: -3, aeloria: -3 } },
        { text: "Send to a retreat.", gold: -20, family: 20 },
        { text: "Support Lysara.", family: 10, people: -10, loyalty_impact: { lysara: 3, aeloria: -3 } },
        { text: "Support Aeloria.", family: 10, people: -10, loyalty_impact: { lysara: -3, aeloria: 3 } },
        { text: "Distract with festival.", gold: -30, people: 30, family: -10 }
    ], 3, "queen", false, false, "lysara", 2, 3),

    new GameEvent(42, "Profeta Idris has incited a revolt...", "idris", [
        { text: "Suppress with troops.", army: -40, people: -40, church: -30 },
        { text: "Negotiate with Idris.", gold: -30, church: 20, force_event: 35 }, // Link para Sombra
        { text: "Excommunicate him.", church: -50, people: -20 },
        { text: "Organize festival.", gold: -30, people: 30, church: -10 },
        { text: "Bribe local leaders.", gold: -40, people: 10 },
        { text: "Ignore revolt.", people: -30, church: -20 }
    ], 3, undefined, false, false, "idris", 2, 3),

    new GameEvent(43, "Lady Sereth Veylith has declared House Veylith independent.", "veylith", [
        { text: "Crush with force.", army: -60, people: -30 },
        { text: "Negotiate peace.", gold: -50, people: 20, loyalty_impact: { veylith: 5 } },
        { text: "Sabotage with Drenkar.", gold: -40, army: 30, unlock_npc: "drenkar" },
        { text: "Church denouncement.", church: 20, people: -10 },
        { text: "Bribe other nobles.", gold: -30, people: 10 },
        { text: "Fortify capital.", supplies: -30, army: 20 }
    ], 3, undefined, false, false, "veylith", 2, 3),

    new GameEvent(44, "A hidden diary reveals a dark pact with the Shadow...", "virellian", [
        { text: "Seek elven aid.", gold: -30, church: 20, force_event: 35 }, // Link para Sombra
        { text: "Hide the diary.", people: -20, family: -20 },
        { text: "Share with Church.", church: 30, people: -30 },
        { text: "Consult Drenkar.", gold: -30, army: 10, unlock_npc: "drenkar" },
        { text: "Burn the diary.", people: -40, family: -10 },
        { text: "Rally against magic.", people: 20, church: 20, army: -10 }
    ], 3, "spymaster", false, false, undefined, 2, 3),

    new GameEvent(45, "Gorak Bloodhowl offers to defect from Yronvall in exchange for gold.", "gorak", [
        { text: "Pay Gorak to join.", gold: -50, army: 40, unlock_npc: "gorak" },
        { text: "Attack mercenaries.", army: -50, people: 20 },
        { text: "Monitor Gorak.", gold: -30, army: 20 },
        { text: "Temporary truce.", gold: -20, people: 10 },
        { text: "Intimidate him.", army: -30, people: -10 },
        { text: "Seek Eldmere's aid.", people: 10, force_event: 33 }
    ], 3, undefined, false, false, "gorak", 2, 3),

    new GameEvent(46, "Drenkar Forgefist offers to craft advanced weapons...", "drenkar", [
        { text: "Pay for weapons.", gold: [-60, -40], army: [50, 70] },
        { text: "Decline offer.", army: [-30, -10] },
        { text: "Hire as spy.", gold: [-40, -20], army: [20, 40] },
        { text: "Lower price.", gold: [-40, -20], army: [30, 50] },
        { text: "Demonstration.", gold: [-30, -10], army: [15, 25] }
    ], 3, undefined, false, false, "drenkar", 2, 3)
];

