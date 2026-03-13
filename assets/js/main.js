(function () {
    'use strict';
    const ICONS = {
        light: '<circle cx="12" cy="12" r="4"/><line x1="12" y1="2" x2="12" y2="5"/><line x1="12" y1="19" x2="12" y2="22"/><line x1="2" y1="12" x2="5" y2="12"/><line x1="19" y1="12" x2="22" y2="12"/><line x1="4.93" y1="4.93" x2="7.05" y2="7.05"/><line x1="16.95" y1="16.95" x2="19.07" y2="19.07"/><line x1="4.93" y1="19.07" x2="7.05" y2="16.95"/><line x1="16.95" y1="7.05" x2="19.07" y2="4.93"/>',
        dark: '<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>'
    };
    const LABELS = { light: 'Light', dark: 'Dark' };
    let currentTheme = 'light';

    const sun = `<circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>`;
    const moon = `<path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>`;

    function setTheme(theme) {
        currentTheme = theme;
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);

        // Desktop single button
        const icon = document.getElementById('theme-icon');
        if (icon) icon.innerHTML = theme === 'dark' ? sun : moon;

        // Mobile toggle button icon + label
        const mIcon = document.getElementById('mobile-theme-icon');
        const mLabel = document.getElementById('mobile-theme-label');
        const mBtn = document.getElementById('mobile-theme-btn');
        if (mIcon) mIcon.innerHTML = ICONS[theme];
        if (mLabel) mLabel.textContent = LABELS[theme];
        if (mBtn) mBtn.classList.toggle('active', theme === 'dark');
    }

    // Desktop single toggle button
    const desktopBtn = document.getElementById('theme-btn');
    if (desktopBtn) desktopBtn.addEventListener('click', () => {
        setTheme(currentTheme === 'light' ? 'dark' : 'light');
    });

    // Mobile toggle button cycles between light and dark
    const mobileBtn = document.getElementById('mobile-theme-btn');
    if (mobileBtn) mobileBtn.addEventListener('click', () => {
        setTheme(currentTheme === 'light' ? 'dark' : 'light');
    });

    // Initialise from localStorage or OS preference
    const saved = localStorage.getItem('theme');
    const darkMQ = window.matchMedia('(prefers-color-scheme: dark)');
    setTheme(saved || (darkMQ.matches ? 'dark' : 'light'));
    darkMQ.addEventListener('change', e => { if (!localStorage.getItem('theme')) setTheme(e.matches ? 'dark' : 'light'); });


    /* ════════════════════════════════════════
       NAVBAR — Scroll shadow + active link
    ════════════════════════════════════════ */
    const navTop = document.getElementById('navbar-top');
    const sectionIds = ['about', 'skills',  'portfolio', 'blogs','resume'];
    const allNavLinks = document.querySelectorAll('.nav-links a, .bottom-nav-inner a');

    window.addEventListener('scroll', () => {
        // Add drop-shadow when page is scrolled
        if (navTop) navTop.classList.toggle('scrolled', window.scrollY > 10);

        // Highlight the nav link matching the current on-screen section
        let current = '';
        sectionIds.forEach(id => {
            const el = document.getElementById(id);
            if (el && window.scrollY >= el.offsetTop - 120) current = id;
        });
        allNavLinks.forEach(a => {
            a.classList.toggle('active', a.getAttribute('href') === '#' + current);
        });
    }, { passive: true });


    /* ════════════════════════════════════════
       SCROLL REVEAL
       Uses IntersectionObserver when available;
       falls back to instant-visible if not.
    ════════════════════════════════════════ */
    const reveals = document.querySelectorAll('.reveal');
    if ('IntersectionObserver' in window) {
        reveals.forEach(el => el.classList.add('will-reveal'));
        const obs = new IntersectionObserver((entries) => {
            entries.forEach(e => {
                if (e.isIntersecting) {
                    e.target.classList.add('visible');
                    obs.unobserve(e.target);
                }
            });
        }, { threshold: 0.08 });
        reveals.forEach(el => obs.observe(el));
    }


    /* ════════════════════════════════════════
       FILTER — shared logic for Portfolio & Blogs
       Works for both pill buttons (desktop)
       and <select> dropdowns (mobile)
    ════════════════════════════════════════ */

    /**
     * Wire up pill button filter bar.
     * @param {string} filterId  — id of the .filter-bar container
     * @param {string} gridId    — id of the card grid
     * @param {string} itemSel   — CSS selector for filterable card elements
     * @param {string} emptyId   — id of the empty-state element
     */
    function initFilter(filterId, gridId, itemSel, emptyId) {
        const bar = document.getElementById(filterId);
        const grid = document.getElementById(gridId);
        const empty = document.getElementById(emptyId);
        if (!bar || !grid) return;

        bar.addEventListener('click', e => {
            const btn = e.target.closest('.filter-btn');
            if (!btn) return;
            bar.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            applyFilter(grid, itemSel, btn.dataset.filter, empty);
        });
    }

    /**
     * Wire up mobile <select> dropdown filter.
     * @param {string} selectId  — id of the <select> element
     * @param {string} gridId    — id of the card grid
     * @param {string} itemSel   — CSS selector for filterable card elements
     * @param {string} emptyId   — id of the empty-state element
     */
    function initSelect(selectId, gridId, itemSel, emptyId) {
        const sel = document.getElementById(selectId);
        const grid = document.getElementById(gridId);
        const empty = document.getElementById(emptyId);
        if (!sel || !grid) return;
        sel.addEventListener('change', () => applyFilter(grid, itemSel, sel.value, empty));
    }

    /** Show/hide cards based on tag match; toggle empty state accordingly. */
    function applyFilter(grid, itemSel, filter, empty) {
        let count = 0;
        grid.querySelectorAll(itemSel).forEach(item => {
            const tags = (item.dataset.tags || '').split(',').map(t => t.trim());
            const show = filter === 'all' || tags.includes(filter);
            item.classList.toggle('hidden', !show);
            if (show) count++;
        });
        if (empty) empty.style.display = count === 0 ? 'block' : 'none';
    }

    initFilter('portfolio-filters', 'portfolio-grid', '.card', 'portfolio-empty');
    initFilter('blog-filters', 'blog-list', '.card', 'blog-empty');
    initSelect('portfolio-select', 'portfolio-grid', '.card', 'portfolio-empty');
    initSelect('blog-select', 'blog-list', '.card', 'blog-empty');


    /* ════════════════════════════════════════
       SMOOTH SCROLL
       Intercepts anchor clicks and smoothly
       scrolls to the target, accounting for
       the fixed navbar height (70px offset)
    ════════════════════════════════════════ */
    document.querySelectorAll('a[href^="#"]').forEach(a => {
        a.addEventListener('click', function (e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                window.scrollTo({
                    top: target.getBoundingClientRect().top + window.scrollY - 70,
                    behavior: 'smooth'
                });
            }
        });
    });


    /* ════════════════════════════════════════
       PRELOADER
       Bar animation: 0.3s delay + 1.6s fill = 1.9s
       Dismiss after 2.3s to allow a graceful fade-out
    ════════════════════════════════════════ */
    const preloader = document.getElementById('preloader');
    setTimeout(() => {
        if (preloader) preloader.classList.add('hidden');
    }, 2300);

})();